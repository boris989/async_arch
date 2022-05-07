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

      @task.update(status: :completed)

      # Buisiness event
      event = {
        event_name: 'Tasks.TaskCompleted',
        data: {
          public_id: @task.public_id,
          account_public_id: @task.account.public_id
        }
      }

      WaterDrop::SyncProducer.call(event.to_json, topic: 'tasks')

      redirect_to employee_tasks_path, notice: 'Task successfully completed.'
    end
  end
end