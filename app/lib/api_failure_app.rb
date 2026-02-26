# frozen_string_literal: true

class ApiFailureApp < Devise::FailureApp
  def respond
    if api_request?
      json_failure
    else
      super
    end
  end

  def json_failure
    self.status = 401
    self.content_type = "application/json"
    self.response_body = { error: i18n_message }.to_json
  end

  def api_request?
    request.path.start_with?("/api/") || request.format.json?
  end
end
