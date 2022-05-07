class Account < ApplicationRecord
  enum role: {
    admin: 'admin',
    manager: 'manager',
    employee: 'employee',
    accountant: 'accountant'
  }
end
