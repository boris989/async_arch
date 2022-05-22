class Account < ApplicationRecord
  has_one :balance, dependent: :destroy
  has_many :tasks, dependent: :destroy
  has_many :transactions, dependent: :destroy

  enum role: {
    admin: 'admin',
    manager: 'manager',
    employee: 'employee',
    accountant: 'accountant'
  }
end
