# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end


puts "Inserting districts..."

distritos = [
  { name: 'Aveiro', code: 'aveiro', language: 'pt' },
  { name: 'Beja', code: 'beja', language: 'pt' },
  { name: 'Braga', code: 'braga', language: 'pt' },
  { name: 'Bragança', code: 'braganca', language: 'pt' },
  { name: 'Castelo Branco', code: 'castelo-branco', language: 'pt' },
  { name: 'Coimbra', code: 'coimbra', language: 'pt' },
  { name: 'Évora', code: 'evora', language: 'pt' },
  { name: 'Faro', code: 'faro', language: 'pt' },
  { name: 'Guarda', code: 'guarda', language: 'pt' },
  { name: 'Leiria', code: 'leiria', language: 'pt' },
  { name: 'Lisboa', code: 'lisboa', language: 'pt' },
  { name: 'Portalegre', code: 'portalegre', language: 'pt' },
  { name: 'Porto', code: 'porto', language: 'pt' },
  { name: 'Santarém', code: 'santarem', language: 'pt' },
  { name: 'Setúbal', code: 'setubal', language: 'pt' },
  { name: 'Viana do Castelo', code: 'viana-do-castelo', language: 'pt' },
  { name: 'Vila Real', code: 'vila-real', language: 'pt' },
  { name: 'Viseu', code: 'viseu', language: 'pt' },
  { name: 'Região Autónoma da Madeira', code: 'madeira', language: 'pt' },
  { name: 'Região Autónoma dos Açores', code: 'acores', language: 'pt' }
]

District.upsert_all(distritos, unique_by: :code)


puts "Inserting guests..."
guests_data = [
  { first_name: 'Ana', last_name: 'Silva', email: 'ana.silva@gmail.com' },
  { first_name: 'João', last_name: 'Pereira', email: 'joao.pereira@gmail.com' },
  { first_name: 'Mariana', last_name: 'Costa', email: 'mariana.costa@gmail.com' }
]

Guest.upsert_all(guests_data, unique_by: :email)


puts "Inserting services..."
services_data = [
  { code: 'general', service_type: 'initial', description: '1ª Consulta de Nutrição Clínica (Geral)' },
  { code: 'general', service_type: 'sequence', description: 'Consulta de seguimento de Nutrição Clínica (Geral)' },
  { code: 'sports', service_type: 'initial', description: '1ª Consulta de Nutrição Desportiva' },
  { code: 'sports', service_type: 'sequence', description: 'Consulta de seguimento de Nutrição Desportiva' },
  { code: 'pediatrics', service_type: 'initial', description: '1ª Consulta de Nutrição Pediátrica' },
  { code: 'pediatrics', service_type: 'sequence', description: 'Consulta de seguimento de Nutrição Pediátrica' },
  { code: 'maternity', service_type: 'initial', description: '1ª Consulta de Nutrição na Gravidez e Pós-parto' }, # <--- Vírgula corrigida
  { code: 'maternity', service_type: 'sequence', description: 'Consulta de seguimento de Nutrição na Gravidez e Pós-parto' }
]
Service.upsert_all(services_data, unique_by: [:code, :service_type])

puts "Inserting nutritionists..."

nutritionists_data = [
  { first_name: 'Sílvia', last_name: 'Mendes', email: 'silvia.mendes@nutrium.com', professional_id: '4521N' },
  { first_name: 'Nuno', last_name: 'Oliveira', email: 'nuno.oliveira@nutrium.com', professional_id: '3188N' },
  { first_name: 'Catarina', last_name: 'Marçal', email: 'catarina.marcal@nutrium.com', professional_id: '5022N' },
  { first_name: 'Gonçalo', last_name: 'Pereira', email: 'gpereira.nutri@nutrium.com', professional_id: '1944N' },
  { first_name: 'José', last_name: 'Ribeiro', email: 'jose.ribeiro.nutri@nutrium.com', professional_id: '6110N' },
  { first_name: 'Joana', last_name: 'Campos', email: 'joana.campos@nutrium.com', professional_id: '9901N' },
  { first_name: 'João', last_name: 'Lopes', email: 'joao.lopes@nutrium.com', professional_id: '9902N' }
]

Nutritionist.upsert_all(nutritionists_data, unique_by: :professional_id)


puts "Inserting catalogs..."

catalog_entries = [
  { p_id: '4521N', s_code: 'sports', s_type: 'initial',   d_code: 'aveiro',  price: 65, dur: 45, addr: 'Rua do Comércio' },
  { p_id: '3188N', s_code: 'general', s_type: 'sequence',  d_code: 'beja',    price: 50, dur: 60, addr: 'Rua da Liberdade' },
  { p_id: '5022N', s_code: 'pediatrics', s_type: 'initial', d_code: 'braga',   price: 55, dur: 50, addr: 'Av. da República' },
  { p_id: '9901N', s_code: 'general', s_type: 'sequence',  d_code: 'lisboa',  price: 80, dur: 60, addr: 'Rua de São Bento' },
  { p_id: '9901N', s_code: 'general', s_type: 'initial',  d_code: 'setúbal', price: 60, dur: 45, addr: 'Rua Principal' },
  { p_id: '9902N', s_code: 'sports',  s_type: 'sequence',  d_code: 'porto',   price: 75, dur: 50, addr: 'Av. dos Aliados' },
  { p_id: '4521N', s_code: 'sports',    s_type: 'sequence', d_code: 'aveiro',   price: 55, dur: 30, addr: 'Rua do Comércio' },
  { p_id: '3188N', s_code: 'general',   s_type: 'initial',  d_code: 'beja',     price: 65, dur: 60, addr: 'Rua da Liberdade' },
  { p_id: '5022N', s_code: 'pediatrics', s_type: 'sequence', d_code: 'braga',    price: 45, dur: 40, addr: 'Av. da República' },
  { p_id: '1944N', s_code: 'maternity', s_type: 'initial',  d_code: 'faro',     price: 70, dur: 60, addr: 'Rua de Santo António' },
  { p_id: '1944N', s_code: 'maternity', s_type: 'sequence', d_code: 'faro',     price: 55, dur: 45, addr: 'Rua de Santo António' },
  { p_id: '6110N', s_code: 'general',   s_type: 'initial',  d_code: 'coimbra',  price: 60, dur: 50, addr: 'Largo da Portagem' },
  { p_id: '9901N', s_code: 'sports',    s_type: 'initial',  d_code: 'lisboa',   price: 90, dur: 60, addr: 'Avenida da Liberdade' },
  { p_id: '9902N', s_code: 'sports',    s_type: 'initial',  d_code: 'porto',    price: 85, dur: 60, addr: 'Rua de Santa Catarina' },
  { p_id: '3188N', s_code: 'maternity', s_type: 'initial',  d_code: 'braga',    price: 65, dur: 60, addr: 'Praça do Giraldo' },
  { p_id: '5022N', s_code: 'general',   s_type: 'initial',  d_code: 'viana-do-castelo', price: 50, dur: 45, addr: 'Rua da Bandeira' }
]

catalog_entries.each do |item|
  nutri    = Nutritionist.find_by(professional_id: item[:p_id])
  service  = Service.find_by(code: item[:s_code], service_type: item[:s_type])
  district = District.find_by(code: item[:d_code].downcase)

  if nutri && service && district
    catalog = Catalog.find_or_create_by!(
      nutritionist: nutri,
      service:      service,
      district:     district
    ) do |c|
      c.price    = item[:price]
      c.duration = item[:dur]
      c.address  = item[:addr]
    end
  end
end


puts "Inserting appointments"

appointment_statuses = Appointment.statuses.keys 
appointment_statuses = Appointment.statuses.keys 

guests = Guest.all
catalogs = Catalog.all

if guests.any? && catalogs.any?
  50.times do |i|
    random_guest = guests.sample
    random_catalog = catalogs.sample

    Appointment.create!(
      guest: random_guest,
      catalog: random_catalog,
      status: appointment_statuses.sample,
      scheduled_at: Time.current + rand(1..30).days + rand(8..18).hours,
    )
  end
 
else

end

puts "Seeds inserted!"