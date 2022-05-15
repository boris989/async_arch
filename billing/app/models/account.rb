class Account < ApplicationRecord
  has_many :transactions
  has_one :balance

  enum role: {
    admin: 'admin',
    manager: 'manager',
    employee: 'employee',
    accountant: 'accountant'
  }
end
