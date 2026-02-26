# frozen_string_literal: true

module Landing
  class InvestmentFormComponent < ::ApplicationComponent
    def initialize(interest: nil)
      @interest = interest || InvestmentInterest.new
    end

    attr_reader :interest
  end
end
