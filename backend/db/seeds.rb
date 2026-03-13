# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end



puts "A inserir distritos..."

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

# Usando o name como critério de unicidade para o upsert
District.upsert_all(distritos, unique_by: :code)


puts "A inserir guests..."
guests_data = [
  { first_name: 'Ana', last_name: 'Silva', email: 'ana.silva@gmail.com' },
  { first_name: 'João', last_name: 'Pereira', email: 'joao.pereira@gmail.com' },
  { first_name: 'Mariana', last_name: 'Costa', email: 'mariana.costa@gmail.com' }
]

Guest.upsert_all(guests_data, unique_by: :email)


puts "A inserir services..."
services_data = [
  { code: 'general', description: 'Consulta de Nutrição Clínica (Geral)' },
  { code: 'sports', description: 'Nutrição Desportiva' },
  { code: 'pediatrics', description: 'Nutrição Pediátrica' },
  { code: 'maternity', description: 'Nutrição na Gravidez e Pós-parto' }
]
Service.upsert_all(services_data, unique_by: :code)


puts "A inserir nutritionists..."

nutritionists_data = [
  { first_name: 'Sílvia', last_name: 'Mendes', email: 'silvia.mendes@nutrium.com', professional_id: '4521N' },
  { first_name: 'Nuno', last_name: 'Oliveira', email: 'nuno.oliveira@nutrium.com', professional_id: '3188N' },
  { first_name: 'Catarina', last_name: 'Teixeira', email: 'catarina.teixeira@nutrium.com', professional_id: '5022N' },
  { first_name: 'Gonçalo', last_name: 'Pereira', email: 'gpereira.nutri@nutrium.com', professional_id: '1944N' },
  { first_name: 'Sofia', last_name: 'Ribeiro', email: 'sofia.ribeiro.nutri@nutrium.com', professional_id: '6110N' },
  { first_name: 'Joana', last_name: 'Campos', email: 'joana.campos@nutrium.com', professional_id: '9901N' },
  { first_name: 'Ricardo', last_name: 'Lopes', email: 'ricardo.lopes@nutrium.com', professional_id: '9902N' }
]

Nutritionist.upsert_all(nutritionists_data, unique_by: :professional_id)


puts "A inserir o catálogo..."

catalog_entries = [
  { p_id: '4521N', s_code: 'sports',    d_code: 'Aveiro',  price: 65.0, dur: 45, addr: 'Rua do Comércio' },
  { p_id: '3188N', s_code: 'general',   d_code: 'Beja',    price: 50.0, dur: 60, addr: 'Rua da Liberdade' },
  { p_id: '5022N', s_code: 'pediatrics', d_code: 'Braga',   price: 55.0, dur: 50, addr: 'Av. da República' },
  { p_id: '9901N', s_code: 'general',   d_code: 'Lisboa',  price: 80.0, dur: 60, addr: 'Rua de São Bento' },
  { p_id: '9901N', s_code: 'general',   d_code: 'Setúbal', price: 60.0, dur: 45, addr: 'Rua Principal' },
  { p_id: '9902N', s_code: 'sports',    d_code: 'Porto',   price: 75.0, dur: 50, addr: 'Av. dos Aliados' }
]

catalog_entries.each do |item|
  # 1. Procuramos os registos nas tabelas pai
  nutri    = Nutritionist.find_by(professional_id: item[:p_id])
  service  = Service.find_by(code: item[:s_code])
  district = District.find_by(name: item[:d_code])

  if nutri && service && district
    # 2. Usamos as chaves estrangeiras explicitamente (_id)
    # Passamos o ID do objeto que encontrámos acima
    Catalog.find_or_create_by!(
      nutritionist_id: nutri.id,
      service_id:      service.id,
      district_id:     district.id
    ) do |c|
      c.price    = item[:price]
      c.duration = item[:dur]
      c.address  = item[:addr]
    end
    print "."
  else
    puts "\n[Erro] Dados em falta para: Nutri #{item[:p_id]} ou Serv #{item[:s_code]}"
  end
end


puts "A gerar 5 agendamentos aleatórios..."

appointment_statuses = Appointment.statuses.keys 

5.times do |i|
  random_guest = Guest.all.sample
  random_catalog = Catalog.all.sample

  Appointment.create!(
    guest: random_guest,
    catalog: random_catalog,
    status: appointment_statuses.sample,
    scheduled_at: DateTime.now + rand(1..30).days + rand(8..18).hours, 
  )
end

puts "Seed concluído com sucesso!"