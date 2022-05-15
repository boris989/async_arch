class Task < ApplicationRecord
  belongs_to :account

  scope :completed_today, -> { where(completed_at: DateTime.current.beginning_of_day..Time.current) }
  scope :completed_this_week, -> { where(completed_at: DateTime.current.beginning_of_week..Time.current) }
  scope :completed_this_month, -> { where(completed_at: DateTime.current.beginning_of_month..Time.current) }
end
