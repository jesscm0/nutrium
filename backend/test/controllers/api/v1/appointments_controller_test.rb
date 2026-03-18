require "test_helper"

class Api::V1::AppointmentsControllerTest < ActionDispatch::IntegrationTest
    test "should get index" do
        get api_v1_appointments_url
        assert_response :success

        json_response = JSON.parse(response.body)

        assert_kind_of Array, json_response

        first_appointment = json_response.first
        
        assert_includes first_appointment, "scheduled_at"
        assert_includes first_appointment, "status"
        assert_includes first_appointment, "guest_id"
    end

    test "should create appointment" do
        catalog = catalogs(:silvia_general_initial)
        post api_v1_appointments_url, 
        params: { 
            guest_email: "jessica@email.com",
            guest_first_name: "Jessica ",
            guest_last_name: " Macedo",
            date:  Time.current.tomorrow.change(hour: 10, min: 0),
            nutritionist_id: catalog.nutritionist_id,
            service_id: catalog.service_id,
            district_id: catalog.district_id
        }, 
        as: :json
      
        assert_response :created 

    end

    test "should create appointment and reject previous pending requests from the same guest" do
        
        guest = guests(:tiago) 
        catalog = catalogs(:silvia_general_initial)

        old_appointment = Appointment.create!(
            guest: guest,
            catalog: catalog,
            scheduled_at: Time.current.tomorrow.change(hour: 10, min: 0),
            status: :pending
        )

        #conting appointment and increment 1 when create success
        assert_difference("Appointment.count", 1) do
            post api_v1_appointments_url, 
            params: { 
                guest_email: guest.email,
                guest_first_name: guest.first_name,
                guest_last_name: guest.last_name,
                date: Time.current.tomorrow.change(hour: 11, min: 0), 
                nutritionist_id: catalog.nutritionist_id,
                service_id: catalog.service_id,
                district_id: catalog.district_id
            }, 
            as: :json
        end

        assert_response :created

        old_appointment.reload
        assert_equal "rejected", old_appointment.status, "O agendamento anterior deveria ter sido rejeitado"
        
        # 5. Verificar se o novo está 'pending'
        new_appointment = Appointment.last
        assert_equal "pending", new_appointment.status
        assert_equal guest.id, new_appointment.guest_id
    end


    test "accepting an appointment should reject overlapping pending requests for the same professional" do
        catalog = catalogs(:silvia_general_initial)
        date = Time.current.tomorrow.change(hour: 14, min: 0, sec: 0, usec: 0)
        
        appt_to_accept = Appointment.create!(
            guest: guests(:tiago), 
            catalog: catalog, 
            scheduled_at: date, 
            status: :pending
        )
        
        appt_to_be_automatic_rejected = Appointment.create!(
            guest: guests(:joana), 
            catalog: catalog, 
            scheduled_at: date, 
            status: :pending
        )

        # Ação: Aceitar o primeiro
        patch api_v1_appointment_url(appt_to_accept), 
                params: { status: :accepted } , 
                as: :json

        #puts "DEBUG BODY: #{response.body}"

        assert_response :success

        # Verificação
        appt_to_accept.reload
        appt_to_be_automatic_rejected.reload

        # puts "DEBUG appt_to_be_automatic_rejected: #{appt_to_be_automatic_rejected.status}"
        assert_equal "accepted", appt_to_accept.status
        assert_equal "rejected", appt_to_be_automatic_rejected.status, "O agendamento concorrente deveria ter sido rejeitado"
        end

end
