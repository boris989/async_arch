class BillingCycle < ApplicationRecord
  has_many :transactions, dependent: :destroy

  enum status: {
    open: 'open',
    closed: 'closed'
  }

  def self.current
    open.last
  end
end
