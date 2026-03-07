# frozen_string_literal: true

require_relative "helpers/mock_data"

Dir[File.join(__dir__, "seeds", "*.rb")].sort.each do |file|
  puts "\n==> #{File.basename(file)}"
  load file
end
