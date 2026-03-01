# frozen_string_literal: true

# Custom Devise failure app that returns JSON for API requests instead of redirecting.
class ApiFailureApp < Devise::FailureApp
  # Responds with JSON for API requests, otherwise delegates to parent.
  # @return [void]
  def respond
    if api_request?
      json_failure
    else
      super
    end
  end

  # Sets 401 status and JSON body with error message.
  # @return [void]
  def json_failure
    self.status = 401
    self.content_type = "application/json"
    self.response_body = { error: i18n_message }.to_json
  end

  # @return [Boolean] true when request path is under /api/ or format is JSON
  def api_request?
    request.path.start_with?("/api/") || request.format.json?
  end
end
