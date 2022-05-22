class TransactionChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      data = HashWithIndifferentAccess.new(message.payload['data'])

      case message.payload['event_name']
      when Events::TRANSACTION_CREATED
        account = Account.find_by(public_id: data[:owner_public_id])

        Transaction.create!(
          public_id: data[:public_id],
          amount: data[:amount],
          kind: data[:kind],
          account: account,
          description: data[:description]
        )
      end
    end
  end
end