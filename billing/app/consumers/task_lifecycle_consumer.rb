class TaskLifecycleConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      data = HashWithIndifferentAccess.new(message.payload['data'])

      case [message.payload['event_name'], message.payload['event_version']]
      when [Events::TASK_ASSIGNED, 1]
        account = get_account(data[:performer_public_id])
        account.with_lock do
          task = get_task(data[:public_id], data[:description])
          task.account = account
          task.save!

          account.transactions.withdrawal.create!(
            credit: task.amount,
            debit: 0,
            description: task.description,
            billing_cycle: BillingCycle.current
          )
        end
      when [Events::TASK_COMPLETED, 1]
        task = get_task(data[:public_id], data[:description])
        account = get_account(data[:performer_public_id])
        task.update!(status: 'completed')
        account.transactions.enrollment.create!(
          debit: task.fee,
          credit: 0,
          description: task.description,
          billing_cycle: BillingCycle.current
        )
      end
    end
  end

  def get_task(public_id, description)
    Task.find_or_create_by(public_id: public_id) do |task|
      task.description = description
    end
  end

  def get_account(public_id)
    Account.find_by(public_id: public_id)
  end
end