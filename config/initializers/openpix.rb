# frozen_string_literal: true

# OpenPix/Woovi webhook signature verification.
# Webhooks are signed with RSA-SHA256 using Woovi's private key.
# Verify using their public key stored in OPENPIX_WEBHOOK_PUBLIC_KEY (base64-encoded PEM).
# If the env var is absent (e.g. development), signature verification is skipped.
#
# Docs: https://developers.openpix.com.br/en/docs/webhook/seguranca/webhook-signature-validation
module Openpix
  WEBHOOK_PUBLIC_KEY_B64 = ENV.fetch("OPENPIX_WEBHOOK_PUBLIC_KEY", nil).freeze
  APP_ID                 = ENV.fetch("OPENPIX_APP_ID", nil).freeze
  API_BASE_URL           = "https://api.openpix.com.br/api/openpix/v1".freeze
end
