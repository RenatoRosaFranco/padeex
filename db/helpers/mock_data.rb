# frozen_string_literal: true

module MockData
  def self.load(filename)
    path = Rails.root.join("data/mocks/#{filename}.json")
    JSON.parse(File.read(path)).map(&:symbolize_keys)
  end
end
