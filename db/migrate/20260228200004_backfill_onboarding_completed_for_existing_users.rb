# frozen_string_literal: true

class BackfillOnboardingCompletedForExistingUsers < ActiveRecord::Migration[8.1]
  def up
    User.where(name: [nil, ""]).update_all(onboarding_completed: false)
    User.where.not(name: [nil, ""]).update_all(onboarding_completed: true)
  end

  def down
    User.update_all(onboarding_completed: false)
  end
end
