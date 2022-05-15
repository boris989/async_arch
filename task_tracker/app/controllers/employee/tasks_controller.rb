module Employee
  class TasksController < ApplicationController
    before_action :authenticate_account!

    def index
      @tasks = current_account.tasks.order(id: :desc)
    end

    def complete
      @task = Task.open.find_by(id: params[:id])
      return head 404 if @task.blank?
      return head 403 if @task.account != current_account
      return head 400 if @task.completed?

      @task.update(status: :completed, completed_at: Time.current)

      # Buisiness event
      event = {
        event_name: Events::TASK_COMPLETED,
        data: {
          public_id: @task.public_id,
          performer_public_id: @task.account.public_id
        }
      }

      WaterDrop::SyncProducer.call(event.to_json, topic: KafkaTopics::TASK_LIFECYCLE)

      # CUD event
      event = {
        event_name: Events::TASK_UPDATED,
        data: {
          public_id: @task.public_id,
          title: @task.title,
          jira_id: @task.jira_id,
          description: @task.description,
          performer_public_id: @task.account.public_id,
          status: @task.status,
          completed_at: @task.completed_at
        }
      }

      WaterDrop::SyncProducer.call(event.to_json, topic: KafkaTopics::TASKS_STREAM)

      redirect_to employee_tasks_path, notice: 'Task successfully completed.'
    end
  end
end