class Api::V1::CatalogsController < ApplicationController
  def index
    # 1. get the catalog and the join tables
    @catalogs = Catalog.includes(:nutritionist, :service, :district)
                       .references(:nutritionist, :service, :district)

    # 2. check the existance of the params
    name_param = params[:name].presence
    location_param = params[:location].presence

    combined_query = "#{name_param} #{location_param}"
  

    # 3. if/else to serach by params
    if name_param && location_param
      @catalogs = @catalogs.search_by_profile(name_param).search_by_location(location_param)

    elsif name_param
      @catalogs = @catalogs.search_by_profile(name_param)

    elsif location_param
      @catalogs = @catalogs.search_by_location(location_param)

    else
      # Caso padrão: Se nada for enviado, mostramos Braga por defeito
      # Aqui usamos o where direto porque é um valor fixo de sistema
      @catalogs = @catalogs.where(districts: { code: 'braga' })
    end

    # 4. Renderização
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