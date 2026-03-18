class Api::V1::AppointmentsController < ApplicationController
  def index
    # 1. get appointments with status pendent and order by scheduled date ascendent
    @appointments = Appointment.includes(:guest, catalog: [:service, :district, :nutritionist])
                               .where(status: :pending)
                               .order(scheduled_at: :asc)

    render json: @appointments.as_json(
      include: {
        guest: { only: [:first_name, :last_name, :email] },
        catalog: { 
          include: { 
            service: { only: [:description] },
            district: { only: [:name] },
            nutritionist: { only: [:first_name, :last_name, :professional_id] }
          },
          only: [:price, :duration, :address]
        }
      }
    )
  end

  def create
    ActiveRecord::Base.transaction do
      # 1. get or create a guest by email
      guest = Guest.find_or_create_by!(email: params[:guest_email]) do |g|
        g.first_name = params[:guest_first_name]
        g.last_name  = params[:guest_last_name]
      end

      # 2. find the catalog associated with the chosen nutritionist, service and location
      catalog = Catalog.find_by(
        nutritionist_id: params[:nutritionist_id], 
        service_id: params[:service_id], 
        district_id: params[:district_id]
      )

      # 3. if the catalog doesnt exist stops the process
      if catalog.nil?
        render json: { errors: ['Nutritionist or catalog doesnt exist'] }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
        return
      end

      # 4. create a new appontment with the guest and catalog in status pending
      @appointment = Appointment.new(
        guest: guest,
        catalog: catalog,
        scheduled_at: params[:date],
        status: :pending
      )

      if @appointment.save
        # 5. if appointment was created, get older pendent appointments and reject them
        reject_appointments = Appointment.where(guest_id: guest.id)
                                         .where.not(id: @appointment.id)
                                         .where(status: :pending).to_a 

        if reject_appointments.any?
          # 6. if older pendent appointment exists, change status to rejected and send email 
          Appointment.where(id: reject_appointments.map(&:id))
                     .update_all(status: :rejected, updated_at: Time.current)

          reject_appointments.each do |appt|
            ApplicationMailer.notify_email(
              appt.guest&.email, 
              appt.guest&.first_name, 
              appt.catalog&.nutritionist&.first_name, 
              appt.scheduled_at.strftime("%d/%m/%Y %H:%M"), 
              "rejected"
            ).deliver_later
          end
        end

        render json: @appointment.as_json(include: [:guest, :catalog]), status: :created
      else
        render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
        raise ActiveRecord::Rollback
      end
    end
  rescue ActiveRecord::RecordInvalid => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end

  def update
    ActiveRecord::Base.transaction do
      # 1. get appointment by id
      @appointment = Appointment.find(params[:id])

      # 2. update status to accepted or rejected and send email
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
        raise ActiveRecord::Rollback
      end

      # 3. If a request is on status accepted, all other overlapping pending requests for the professional, must be automatically rejected
      if @appointment.accepted? 
        # 4. calculate the end of the appoitnment in minutes
        end_time = @appointment.scheduled_at + @appointment.catalog.duration.minutes

        overlapping_appointments = Appointment.joins(:catalog)
                                              .where(catalogs: { nutritionist_id: @appointment.catalog.nutritionist_id })
                                              .where(status: :pending)
                                              .where.not(id: @appointment.id)
                                              .where("scheduled_at < ? AND scheduled_at >= ?", 
                                                    end_time, 
                                                    @appointment.scheduled_at).to_a 

        # 5. if exists overlapping appointments reject them and send email                                             
        if overlapping_appointments.any?
          ids = overlapping_appointments.map(&:id)
          Appointment.where(id: ids).update_all(status: :rejected, updated_at: Time.current)

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
    rescue ActiveRecord::RecordInvalid => e
    render json: { errors: [e.message] }, status: :unprocessable_entity
  end
end