# frozen_string_literal: true

FeatureFlags::REGISTRY.each do |flag|
  Flipper.enable(flag)
  puts "Feature flag enabled: #{flag}"
end
