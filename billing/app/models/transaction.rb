class Transaction < ApplicationRecord
  belongs_to :account
  belongs_to :billing_cycle

  enum kind: {
    enrollment: 'enrollment',
    withdrawal: 'withdrawal',
    payment: 'payment'
  }

  after_create do
    balance = account.balance

    balance.amount += debit
    balance.amount -= credit

    balance.save!

    self.reload

    ProduceEvent.call(
      event_name: Events::TRANSACTION_APPLIED,
      event_version: 1,
      schema: 'billing.transaction_applied',
      topic: KafkaTopics::TRANSACTIONS_APPLIED,
      data: {
        public_id: public_id,
        owner_public_id: account.public_id,
        debit: debit,
        credit: credit,
        description: description,
        kind: kind
      }
    )
  end
end
