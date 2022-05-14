class TasksController < ApplicationController
  before_action :authenticate_account!
  before_action :set_task, only: %i[edit update]

  def index
    @tasks = Task.all.includes(:account).order(id: :desc)
  end

  def new
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    @task.account = employee_accounts.sample
    if @task.save
      @task.reload

      # CUD event
      create_event = {
        event_name: 'Tasks.TaskCreated',
        data: {
          public_id: @task.public_id,
          title: @task.title,
          description: @task.description,
          performer_public_id: @task.account.public_id
        }
      }

      WaterDrop::SyncProducer.call(create_event.to_json, topic: KafkaTopics::TASKS_STREAM)

      # Buisiness event
      add_event = {
        event_name: 'Tasks.TaskAdded',
        data: {
          public_id: @task.public_id,
          title: @task.titile,
          description: @task.description,
          performer_public_id: @task.account.public_id
        }
      }

      WaterDrop::SyncProducer.call(add_event.to_json, topic: KafkaTopics::TASK_LIFYCYCLE)

      # Buisiness event
      assing_event = {
        event_name: 'Tasks.TaskAssigned',
        data: {
          public_id: @task.public_id,
          performer_public_id: @task.account.public_id
        }
      }

      WaterDrop::SyncProducer.call(assing_event.to_json, topic: KafkaTopics::TASK_LIFYCYCLE)

      redirect_to root_path, notice: 'Task successfully added.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      # CUD event
      event = {
        event_name: 'Tasks.TaskUpdated',
        data: {
          public_id: @task.public_id,
          title: @task.title,
          description: @task.description
        }
      }

      WaterDrop::SyncProducer.call(event.to_json, topic: KafkaTopics::TASKS_STREAM)
      redirect_to root_path, notice: 'Task successfully updated.'
    else
      render :edit
    end
  end

  def shuffle
    @open_tasks = Task.open

    @open_tasks.each do |task|
      task.update(account: employee_accounts.sample)

      # Buisiness event
      assing_event = {
        event_name: 'Tasks.TaskAssigned',
        data: {
          public_id: task.public_id,
          performer_public_id: task.account.public_id
        }
      }

      WaterDrop::SyncProducer.call(assing_event.to_json, topic: KafkaTopics::TASK_LIFYCYCLE)
    end

    redirect_to root_path, notice: 'Tasks successfully assigned.'
  end

  private

  def task_params
    params.require(:task).permit(:title, :description)
  end

  def employee_accounts
    @employee_accounts ||= Account.employee
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
