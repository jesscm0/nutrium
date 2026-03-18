class Api::V1::CatalogsController < ApplicationController
  def index
    
    Rails.logger.info "Name: #{params[:name]}, Location: #{params[:location]}"

    if params[:location].present?
      location_code = District.find_by(code: params[:location])&.code || "braga" #se não encontrar nenhum distrito ou enviar algum nome inválido o default é Braga
    end  
  
    if params[:name].present? && params[:location].present?
       #search_term = "%#{params[:name].downcase.squish}%"
     
     
      Rails.logger.info "search_term recebido: #{@search_term}"
        @catalogs = Catalog.includes(:nutritionist, :service, :district)
                      .where(districts: { code: location_code })
                      #.where("services.description ILIKE ? OR nutritionists.first_name ILIKE ? OR nutritionists.last_name ILIKE ?", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
                      .references(:district)
        @catalogs = @catalogs.search_by_text(params[:name])


    elsif params[:name].present? && params[:location].blank?
      #search_term = "%#{params[:name].downcase.squish}%"

      @catalogs = Catalog.includes(:nutritionist, :service)
      #                 .where("services.description ILIKE ? OR nutritionists.first_name ILIKE ? OR nutritionists.last_name ILIKE ?", "%#{search_term}%", "%#{search_term}%", "%#{search_term}%")
                        .references(:nutritionist)
      @catalogs = @catalogs.search_by_text(params[:name])

    elsif params[:name].blank? && params[:location].present?
      @catalogs = Catalog.includes(:nutritionist, :service, :district)
                       .where(districts: { code: location_code })
                       .references(:district)
    else
      @catalogs = Catalog.includes(:nutritionist, :service, :district).all
    end
      

    render json: @catalogs.as_json(
      include: { 
        service: { only: [:description, :id, :service_type] },
        district: { only: [:name, :id] },
        nutritionist: { only: [:first_name, :last_name, :professional_id, :id] },
      },
      only: [:price, :duration, :address],
      methods: [:location, :name]
    )
  end
end
