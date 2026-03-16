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

  def show
    
    @appointment = Appointment.includes(:guest, :nutritionist, catalog: :service).find(params[:id])
    render json: @appointment.as_json(
      include: {
        guest: { only: [:first_name, :last_name, :email] },
        nutritionist: { only: [:first_name, :last_name, :professional_id] },
        catalog: { 
          include: { 
            service: { only: [:description] },
            district: { only: [:name] }
          },
          only: [:price, :duration, :address]
        }
      }
    )
  end

  def create
    ActiveRecord::Base.transaction do
      # 1. Encontrar ou criar o Guest pelo email
      guest = Guest.find_or_create_by!(email: params[:guest_email]) do |g|
        g.first_name = params[:guest_first_name]
        g.last_name  = params[:guest_last_name]
      end

      puts " Nutricionista id: (#{params[:nutritionist_id]})"


      # 2. Encontrar o Nutricionista (pelo professional_id ou ID)
      nutritionist = Nutritionist.find(params[:nutritionist_id])

      catalog = Catalog.find_by(nutritionist_id: nutritionist.id, service_id: params[:service_id], district_id: params[:district_id])
      
      puts "catalog id: (#{catalog.id})"

      puts "Encontrado Nutricionista: #{nutritionist.first_name} #{nutritionist.last_name}"

      scheduled_datetime = params[:date]

      # 4. Criar o Appointment
      @appointment = Appointment.create!(
        guest: guest,
        catalog: catalog,
        scheduled_at: scheduled_datetime,
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
  end


end
