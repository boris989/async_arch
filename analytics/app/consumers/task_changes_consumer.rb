class TaskChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      data = HashWithIndifferentAccess.new(message.payload['data'])

      case message.payload['event_name']
      when Events::TASK_CREATED
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
        end
      when Events::TASK_UPDATED
        task = get_task(data[:public_id])
        account = Account.find_by(public_id: data[:performer_public_id])

        task.assign_attributes(
          public_id: data[:public_id],
          title: data[:title],
          jira_id: data[:jira_id],
          description: data[:description],
          account: account,
          status: data[:status],
          completed_at: data[:completed_at]
        )

        task.save!
      end
    end
  end


  def get_task(public_id)
    Task.find_or_create_by(public_id: public_id)
  end
end