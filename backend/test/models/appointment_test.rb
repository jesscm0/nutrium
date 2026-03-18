require "test_helper"

class AppointmentTest < ActiveSupport::TestCase
  setup do
    @guest = guests(:tiago) 
    @catalog = catalogs(:silvia_general_initial)
  end

  test "should not save appointment in the past" do
    appointment = Appointment.new(
      guest: @guest,
      catalog: @catalog,
      scheduled_at: 2.day.ago,
      status: :pending
    )
    assert_not appointment.valid?  #Ensures that appointment valid is false.
    assert_includes appointment.errors[:scheduled_at], "cannot be in the past" #Ensures that this error is included because date was 2 days ago
  end

  
end
