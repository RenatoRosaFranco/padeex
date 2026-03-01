# frozen_string_literal: true

module FeatureFlags
  # Central registry — add new flags here with a description.
  REGISTRY = {
    feed:         "Feed de publicações (estilo Instagram) no dashboard",
    released_app: "App lançado publicamente (exibe landing page de lançamento)",
    store:        "Loja de produtos de padel (navbar + página /loja)"
  }.freeze

  def self.enabled?(flag)
    Flipper.enabled?(flag)
  rescue StandardError
    false
  end
end
