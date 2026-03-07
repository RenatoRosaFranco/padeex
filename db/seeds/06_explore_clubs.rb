# frozen_string_literal: true

padel = Tenant.find_by!(slug: "padel")

clubs = MockData.load("clubs")

clubs.each do |attrs|
  user = User.find_or_initialize_by(email: "clube-#{attrs[:name].parameterize}@seed.padeex.com.br")
  user.assign_attributes(
    name:                attrs[:name],
    password:            "padex@123",
    accepted_terms:      true,
    kind:                "club",
    onboarding_completed: true,
    tenant:              padel
  )
  user.save!(validate: false)

  ClubProfile.find_or_create_by!(user: user) do |p|
    p.club_name           = attrs[:name]
    p.cnpj                = "00.000.000/0001-#{format('%02d', clubs.index(attrs) + 1)}"
    p.address             = attrs[:address]
    p.phone               = attrs[:phone]
    p.cancellation_hours  = 24
    p.latitude            = attrs[:lat]
    p.longitude           = attrs[:lng]
  end
end

puts "  #{clubs.size} clubs with coordinates"
