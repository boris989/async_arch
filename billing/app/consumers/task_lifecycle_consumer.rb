class TaskLifecycleConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      data = HashWithIndifferentAccess.new(message.payload['data'])

      case message.payload['event_name']
      when Events::TASK_ASSIGNED
        task = get_task(data[:public_id])
        account = get_account(data[:performer_public_id])

        task.account = account
        task.save!

        account.transactions.withdrawal.create!(amount: task.cost, description: task.description)

      when Events::TASK_COMPLETED
        task = get_task(data[:public_id])
        account = get_account(data[:performer_public_id])
        task.update!(status: 'completed')
        account.transactions.enrollment.create!(amount: task.fee, description: task.description)
      end
    end
  end


  def get_task(public_id)
    Task.find_or_create_by(public_id: public_id)
  end

  def get_account(public_id)
    Account.find_by(public_id: public_id)
  end
end