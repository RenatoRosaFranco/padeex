# frozen_string_literal: true

module Actions
  # Finds a single record within a scope by primary key or by a custom column.
  #
  # Context inputs:
  #   - scope  [ActiveRecord::Relation, Class] AR class or scoped relation to search within
  #   - id     [Integer, String] value to match against the primary key or custom column
  #   - column [Symbol, nil]     when present, matches id against this column instead of primary key
  #
  # Context outputs:
  #   - record [ActiveRecord::Base] the found record
  class Find < BaseInteractor
    def call
      context.record = find_record
    rescue ActiveRecord::RecordNotFound
      fail_with!(error: I18n.t("errors.not_found"))
    end

    private

    # @return [ActiveRecord::Base]
    def find_record
      if context.column
        context.scope.find_by!(context.column => context.id)
      else
        context.scope.find(context.id)
      end
    end
  end
end
