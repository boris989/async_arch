class AccountChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      data = HashWithIndifferentAccess.new(message.payload['data'])

      case message.payload['event_name']
      when Events::ACCOUNT_CREATED
        Account.create!(
          public_id: data[:public_id],
          email: data[:email],
          full_name: data[:full_name],
          role: data[:role]
        )
      when Events::ACCOUNT_UPDATED
        account = get_account(data[:public_id])
        account.update(full_name: data[:full_name])
      when Events::ACCOUNT_DELETED
      when Events::ACCOUNT_ROLE_CHANGED
        account = get_account(data[:public_id])
        account.update(role: data[:role])
      end
    end
  end


  def get_account(public_id)
    Account.find_by(public_id: public_id)
  end
end