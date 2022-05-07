class Task < ApplicationRecord
  belongs_to :account

  enum status: {
    in_progress: 'in_progress',
    completed: 'completed'
  }

  validates :description, presence: true
end
