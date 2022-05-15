class TaskCostsChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      data = HashWithIndifferentAccess.new(message.payload['data'])

      case message.payload['event_name']
      when Events::TASK_COSTS_CREATED
        task = get_task(data[:task_public_id])
        task.assign_attributes(
          amount: data[:amount],
          fee: data[:fee]
        )

        task.save!
      end
    end
  end

  def get_task(public_id)
    Task.find_or_create_by(public_id: public_id)
  end
end