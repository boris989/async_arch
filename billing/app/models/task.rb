class Task < ApplicationRecord
  belongs_to :account

  before_create do
    self.amount = rand(10..20)
    self.fee = rand(20..40)
  end
end
