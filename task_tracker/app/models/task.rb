class Task < ApplicationRecord
  belongs_to :account

  enum status: {
    open: 'open',
    completed: 'completed'
  }

  validates :description, presence: true

  validate :jira_id_not_in_title

  def jira_id_not_in_title
    return if !title.match(/[\[\]]/)

    errors.add(:title, 'contains jira_id')
  end
end
