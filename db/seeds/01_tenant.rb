# frozen_string_literal: true

Tenant.find_or_create_by!(slug: "padel") { |t| t.name = "Padel" }
puts "Tenant: padel"
