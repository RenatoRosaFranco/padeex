# frozen_string_literal: true

padel = Tenant.find_by!(slug: "padel")

# Admin
admin = User.find_or_initialize_by(email: "admin@padeex.com.br")
admin.assign_attributes(
  name: "Admin PADEX",
  password: "padex@123",
  accepted_terms: true,
  admin: true,
  kind: "user",
  onboarding_completed: true,
  tenant: padel
)
admin.save!(validate: false)
puts "User: admin@padeex.com.br (admin)"

# Athlete (user)
athlete = User.find_or_initialize_by(email: "atleta@padeex.com.br")
athlete.assign_attributes(
  name: "Rafael Mendes",
  password: "padex@123",
  accepted_terms: true,
  kind: "user",
  onboarding_completed: true,
  tenant: padel
)
athlete.save!(validate: false)

UserProfile.find_or_create_by!(user: athlete) do |p|
  p.username   = "rafamendes"
  p.birth_date = Date.new(1995, 6, 15)
  p.gender     = "male"
end
puts "User: atleta@padeex.com.br (athlete)"

# Club
club_user = User.find_or_initialize_by(email: "clube@padeex.com.br")
club_user.assign_attributes(
  name: "Arena Padel SP",
  password: "padex@123",
  accepted_terms: true,
  kind: "club",
  onboarding_completed: true,
  tenant: padel
)
club_user.save!(validate: false)

ClubProfile.find_or_create_by!(user: club_user) do |p|
  p.club_name          = "Arena Padel SP"
  p.cnpj               = "12.345.678/0001-99"
  p.address            = "Av. Paulista, 1000 – São Paulo, SP"
  p.phone              = "(11) 91234-5678"
  p.cancellation_hours = 24
end
puts "User: clube@padeex.com.br (club)"

# Brand
brand_user = User.find_or_initialize_by(email: "marca@padeex.com.br")
brand_user.assign_attributes(
  name: "Wilson Padel Brasil",
  password: "padex@123",
  accepted_terms: true,
  kind: "brand",
  onboarding_completed: true,
  tenant: padel
)
brand_user.save!(validate: false)

BrandProfile.find_or_create_by!(user: brand_user) do |p|
  p.brand_name = "Wilson Padel Brasil"
  p.cnpj       = "98.765.432/0001-11"
  p.category   = "raquetes"
end

integrations = [
  { provider: "woocommerce",  store_url: "https://wilsonpadel.com.br", api_key: "wc_demo_key_123", status: "active" },
  { provider: "mercadolivre", store_url: "https://loja.mercadolivre.com.br/wilson", api_key: "ml_demo_key_456", status: "active" }
]

integrations.each do |attrs|
  BrandIntegration.find_or_create_by!(brand_profile: brand_profile, provider: attrs[:provider]) do |i|
    i.store_url = attrs[:store_url]
    i.api_key   = attrs[:api_key]
    i.status    = attrs[:status]
  end
end

puts "User: marca@padeex.com.br (brand, #{integrations.size} integrations)"
