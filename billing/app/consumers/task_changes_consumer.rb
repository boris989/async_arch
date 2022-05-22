class TaskChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      data = HashWithIndifferentAccess.new(message.payload['data'])

      case [message.payload['event_name'], message.payload['event_version']]
      when [Events::TASK_CREATED, 1]
        account = Account.find_by(public_id: data[:performer_public_id])
        account.with_lock do
          task = get_task(data[:public_id])
          task.assign_attributes(
            public_id: data[:public_id],
            title: data[:title],
            jira_id: data[:jira_id],
            description: data[:description],
            account: account,
            status: data[:status]
          )

          task.save!

          event = {
            event_name: Events::TASK_COSTS_CREATED,
            data: {
              task_public_id: task.public_id,
              amount: task.amount,
              fee: task.fee
            }
          }

          WaterDrop::SyncProducer.call(event.to_json, topic: KafkaTopics::TASK_COSTS_STREAM)
        end
      when [Events::TASK_UPDATED, 1]
        task = get_task(data[:public_id])
        account = Account.find_by(public_id: data[:performer_public_id])

        task.assign_attributes(
          public_id: data[:public_id],
          title: data[:title],
          jira_id: data[:jira_id],
          description: data[:description],
          account: account,
          status: data[:status]
        )

        task.save!
      end
    end
  end


  def get_task(public_id)
    Task.find_or_create_by(public_id: public_id)
  end
end