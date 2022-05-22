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

    event = {
      event_name: Events::TRANSACTION_CREATED,
      data: {
        public_id: public_id,
        owner_public_id: account.public_id,
        debit: debit,
        credit: credit,
        description: description,
        kind: kind
      }
    }

    WaterDrop::SyncProducer.call(event.to_json, topic: KafkaTopics::TRANSACTIONS_STREAM)
  end
end
