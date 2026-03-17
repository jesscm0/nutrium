class Api::V1::AppointmentsController < ApplicationController
  def index
    #@appointments = Appointment.all
    #render json: @appointments

    @appointments = Appointment.includes(:guest, :nutritionist, catalog: :service)
                           .where(status: 0)
                           .order(scheduled_at: :asc)

    render json: @appointments.as_json(
      include: {
        guest: { only: [:first_name, :last_name, :email] },
        catalog: { 
          include: { 
            service: { only: [:description] },
            district: { only: [:name] },
            nutritionist: { only: [:first_name, :last_name, :professional_id] },
          },
          only: [:price, :duration, :address]
        }
      }
    )
  end

  def create

    ActiveRecord::Base.transaction do

      #1. Find or create the guest based on the provided email
      guest = Guest.find_or_create_by!(email: params[:guest_email]) do |g|
        g.first_name = params[:guest_first_name]
        g.last_name  = params[:guest_last_name]
      end

      nutritionist = Nutritionist.find(params[:nutritionist_id])

      catalog = Catalog.find_by(nutritionist_id: nutritionist.id, service_id: params[:service_id], district_id: params[:district_id])

      #A guest can only have one pending appointment request (i.e., submitting a new pendingrequest must invalidate the existing ones from the same guest)
      @pending_appointments = Appointment.find_by(guest: guest, status: :pending)
      @pending_appointments&.update_all(status: :cancelled)

      @appointment = Appointment.create!(
        guest: guest,
        catalog: catalog,
        scheduled_at: params[:date],
        status: Appointment.statuses[:pending]
      )

      render json: @appointment.as_json(include: [:guest, :catalog]), status: :created
    end
  end

  def update
    @appointment = Appointment.find(params[:id])
    Rails.logger.info "Status recebido: #{params[:status]}"

    if @appointment.update(status: params[:status])
      
      email = @appointment.guest&.email
      name = @appointment.guest&.first_name
      status = @appointment.status
      nutritionist = @appointment.catalog&.nutritionist&.first_name
      date = @appointment.scheduled_at.strftime("%d/%m/%Y %H:%M")

      ApplicationMailer.notify_email(email, name, nutritionist, date, status).deliver_later 
      
      render json: @appointment, status: :ok
    else
      render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
    end

    #If a request is accepted, all other overlapping pending requests for the professional, must be automatically rejected
    if @appointment.accepted?
      overlapping_appointments = Appointment.joins(:catalog)
                                            .where(catalogs: { nutritionist_id: @appointment.catalog.nutritionist_id })
                                            .where(status: :pending)
                                            .where.not(id: @appointment.id)
                                            .where("scheduled_at < ? AND scheduled_at > ?", @appointment.scheduled_at + @appointment.catalog.duration, @appointment.scheduled_at)

      overlapping_appointments.update_all(status: :rejected)

      overlapping_appointments.each do |appt|
        email = appt.guest&.email
        name = appt.guest&.first_name
        status = appt.status
        nutritionist = appt.catalog&.nutritionist&.first_name
        date = appt.scheduled_at.strftime("%d/%m/%Y %H:%M")

        ApplicationMailer.notify_email(email, name, nutritionist, date, status).deliver_later 
      end
        
    end
    

  end


end
