module Popularable
  extend ActiveSupport::Concern

  PERIODS={'weekly': 7, 'monthly': 30, 'quarterly': 92}

  included do
    PERIODS.each do |key, value|
      define_singleton_method  "popularity_on_#{key}_basis" do
        recommendations_by_popularity.
          where(created_at: value.days.ago.midnight..Time.now).
          limit(6)
      end
    end
  end
end
