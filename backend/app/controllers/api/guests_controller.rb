# app/controllers/api/guests_controller.rb
module Api
  class GuestsController < ApplicationController
    def index
      @guests = Guest.all
      render json: @guests
    end
  end
end