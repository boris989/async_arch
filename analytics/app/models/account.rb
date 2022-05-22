class Account < ApplicationRecord
  has_one :balance

  enum role: {
    admin: 'admin',
    manager: 'manager',
    employee: 'employee',
    accountant: 'accountant'
  }
end
