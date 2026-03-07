# frozen_string_literal: true

Tenant.find_or_create_by!(slug: "padel") do |t|
  t.name   = "Padel"
  t.domain = "padeex.com.br"
end

puts "Tenant: padel (padeex.com.br)"
