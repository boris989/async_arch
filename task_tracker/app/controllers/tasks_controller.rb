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
      ProduceEvent.call(
        event_name: Events::TASK_CREATED,
        event_version: 1,
        schema: 'task_tracker.task_created',
        topic: KafkaTopics::TASKS_STREAM,
        data: {
          public_id: @task.public_id,
          title: @task.title,
          jira_id: @task.jira_id,
          description: @task.description,
          performer_public_id: @task.account.public_id,
          status: @task.status
        }
      )

      # Buisiness event
      ProduceEvent.call(
        event_name: Events::TASK_ADDED,
        event_version: 1,
        schema: 'task_tracker.task_added',
        topic: KafkaTopics::TASK_LIFECYCLE,
        data: {
          public_id: @task.public_id,
          title: @task.title,
          jira_id: @task.jira_id,
          description: @task.description,
          performer_public_id: @task.account.public_id,
          status: @task.status
        }
      )

      # Buisiness event
      ProduceEvent.call(
        event_name: Events::TASK_ASSIGNED,
        event_version: 1,
        schema: 'task_tracker.task_assigned',
        topic: KafkaTopics::TASK_LIFECYCLE,
        data: {
          public_id: @task.public_id,
          performer_public_id: @task.account.public_id,
          description: @task.description
        }
      )

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
      ProduceEvent.call(
        event_name: Events::TASK_UPDATED,
        event_version: 1,
        schema: 'task_tracker.task_updated',
        topic: KafkaTopics::TASKS_STREAM,
        data: {
          public_id: @task.public_id,
          title: @task.title,
          jira_id: @task.jira_id,
          description: @task.description,
          performer_public_id: @task.account.public_id,
          status: @task.status,
          completed_at: @task.completed_at
        }
      )
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
      ProduceEvent.call(
        event_name: Events::TASK_ASSIGNED,
        event_version: 1,
        schema: 'task_tracker.task_assigned',
        topic: KafkaTopics::TASK_LIFECYCLE,
        data: {
          public_id: task.public_id,
          performer_public_id: task.account.public_id,
          description: task.description
        }
      )
    end

    redirect_to root_path, notice: 'Tasks successfully assigned.'
  end

  private

  def task_params
    params.require(:task).permit(:title, :description, :jira_id)
  end

  def employee_accounts
    @employee_accounts ||= Account.employee
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
