class Task < ApplicationRecord
  belongs_to :account

  enum status: {
    open: 'open',
    completed: 'completed'
  }

  validates :description, presence: true
end
