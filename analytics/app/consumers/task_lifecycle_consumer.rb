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
          task = get_task(data[:public_id])
          task.account = account
          task.save!
        end
      when [Events::TASK_COMPLETED, 1]
        task = get_task(data[:public_id])
        task.update!(status: 'completed', completed_at: data[:completed_at])
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