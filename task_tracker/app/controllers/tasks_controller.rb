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
      redirect_to root_path, notice: 'Task successfully added.'
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @task.update(task_params)
      redirect_to root_path, notice: 'Task successfully updated.'
    else
      render :edit
    end
  end

  def shuffle
    @open_tasks = Task.open

    @open_tasks.each do |task|
      task.update(account: employee_accounts.sample)
    end

    redirect_to root_path, notice: 'Tasks successfully assigned.'
  end

  private

  def task_params
    params.require(:task).permit(:description)
  end

  def employee_accounts
    @employee_accounts ||= Account.employee
  end

  def set_task
    @task = Task.find(params[:id])
  end
end
