module Filterable
  extend ActiveSupport::Concern

  included do
    scope :today, -> { where('updated_at >= ? and updated_at <= ?', Time.current.beginning_of_day, Time.current.end_of_day) }
    scope :yesterday, -> { where('updated_at >= ? and updated_at <= ?', Time.current.yesterday.beginning_of_day, Time.current.yesterday.end_of_day) }
    scope :last_7_days, -> { where('updated_at >= ? and updated_at <= ?', (Time.current-7.days).beginning_of_day, Time.current) }
    scope :last_30_days, -> { where('updated_at >= ? and updated_at <= ?', (Time.current-30.days).beginning_of_day, Time.current) }
    scope :last_90_days, -> { where('updated_at >= ? and updated_at <= ?', (Time.current-90.days).beginning_of_day, Time.current) }
  end

end
