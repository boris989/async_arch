class Transaction < ApplicationRecord
  belongs_to :account

  enum kind: {
    enrollment: 'enrollment',
    withdrawal: 'withdrawal',
    payment: 'payment'
  }

  scope :today, -> { where(created_at:  DateTime.current.beginning_of_day..Time.current)}

  after_create do
    balance = account.balance

    if enrollment?
      balance.amount += amount
    else
      balance.amount -= amount
    end

    balance.save!
  end
end
