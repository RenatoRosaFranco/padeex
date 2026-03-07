# frozen_string_literal: true

class Newsletter::UnsubscribesController < ApplicationController
  layout "auth"

  def show
    user = User.find_by(unsubscribe_token: params[:token])

    if user.nil?
      render :invalid and return
    end

    user.unsubscribe! unless user.newsletter_subscribed == false
  end
end
