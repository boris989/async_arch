class AccountChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      data = HashWithIndifferentAccess.new(message.payload['data'])

      case message.payload['event_name']
      when 'Auth.AccountCreated'
        Account.create!(
          public_id: data[:public_id],
          email: data[:email],
          full_name: data[:full_name],
          role: data[:role]
        )
      when 'Auth.AccountUpdated'
        account = get_account(data[:public_id])
        account.update(full_name: data[:full_name])
      when 'Auth.AccountDeleted'
      when 'Auth.AccountRoleChanged'
        account = get_account(data[:public_id])
        account.update(role: data[:role])
      end
    end
  end


  def get_account(public_id)
    @account ||= Account.find_by(public_id: public_id)
  end
end