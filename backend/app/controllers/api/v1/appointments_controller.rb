class Api::V1::AppointmentsController < ApplicationController
  def index
    @appointments = Appointment.all
    render json: @appointments
  end

  def show
    @appointment = Appointment.find(params[:id])
    render json: @appointment
  end

  def create
  end

  def update
  end
end
