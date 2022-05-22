module Employee
  class TasksController < ApplicationController
    before_action :authenticate_account!

    def index
      @tasks = current_account.tasks.order(id: :desc)
    end

    def complete
      @task = Task.open.find_by(id: params[:id])
      return head 404 if @task.blank?
      #return head 403 if @task.account != current_account
      return head 400 if @task.completed?

      @task.update(status: :completed, completed_at: Time.current)

      # Buisiness event

      ProduceEvent.call(
        event_name: Events::TASK_COMPLETED,
        event_version: 1,
        schema: 'task_tracker.task_completed',
        topic: KafkaTopics::TASK_LIFECYCLE,
        data: {
          public_id: @task.public_id,
          performer_public_id: @task.account.public_id,
          description: @task.description,
          completed_at: @task.completed_at.to_s
        }
      )

      redirect_to employee_tasks_path, notice: 'Task successfully completed.'
    end
  end
end