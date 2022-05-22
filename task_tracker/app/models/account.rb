class Account < ApplicationRecord
  has_many :tasks, dependent: :destroy

  enum role: {
    admin: 'admin',
    manager: 'manager',
    employee: 'employee',
    accountant: 'accountant'
  }
end
