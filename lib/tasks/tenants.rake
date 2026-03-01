# frozen_string_literal: true

namespace :tenants do
  desc "Create a new tenant (sport). Usage: rails tenants:create slug=handball name=Handball"
  task create: :environment do
    slug = ENV["slug"] || ENV["SLUG"]
    name = ENV["name"] || ENV["NAME"]

    if slug.blank? || name.blank?
      puts "Usage: rails tenants:create slug=handball name=Handball"
      exit 1
    end

    tenant = Tenant.find_or_create_by!(slug: slug) { |t| t.name = name }
    puts "Tenant created: #{tenant.slug} (#{tenant.name})"
  end

  desc "List all tenants"
  task list: :environment do
    Tenant.order(:slug).each { |t| puts "#{t.slug}: #{t.name}" }
  end
end
