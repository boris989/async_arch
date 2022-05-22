class Account < ApplicationRecord
  has_many :transactions, dependent: :destroy
  has_one :balance, dependent: :destroy
  has_many :tasks, dependent: :destroy

  enum role: {
    admin: 'admin',
    manager: 'manager',
    employee: 'employee',
    accountant: 'accountant'
  }
end
