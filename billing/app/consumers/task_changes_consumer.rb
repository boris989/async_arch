class TaskChangesConsumer < ApplicationConsumer
  def consume
    params_batch.each do |message|
      puts '-' * 80
      p message
      puts '-' * 80

      data = HashWithIndifferentAccess.new(message.payload['data'])

      case message.payload['event_name']
      when Events::TASK_CREATED
        task = get_task(data[:public_id])
        account = Account.find_by(public_id: data[:performer_public_id])

        cost = rand(10..20)
        fee = rand(20..40)

        task.assign_attributes(
          public_id: data[:public_id],
          title: data[:title],
          jira_id: data[:jira_id],
          description: data[:description],
          account: account,
          cost: cost,
          fee: fee,
          status: data[:status]
        )

        task.save!
      when Events::TASK_UPDATED
        p '-----------------------------------------------'
        p  data[:performer_public_id]
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
    Task.find_or_initialize_by(public_id: public_id)
  end
end