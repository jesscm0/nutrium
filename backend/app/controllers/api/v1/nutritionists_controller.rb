class Api::V1::NutritionistsController < ApplicationController
  def index
    @nutritionists = Nutritionist.all

    if params[:name].present?
      search_term = "%#{params[:name].downcase.squish}%"

      puts "Search term: #{search_term}"

      @nutritionists = @nutritionists.where(
        "lower(first_name || ' ' || last_name) LIKE ?", 
        search_term
      )
    end

    
    render json: @nutritionists.as_json();
    
   # .includes(:services).where(
   #   services: { id: params[:service_id] } , 
   #   districts: { id: params[:district_id] },
   #   only: [:id, :first_name, :last_name, :professional_id])
  end
end
