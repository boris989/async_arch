class DashboardController < ApplicationController
  before_action :authenticate_account!

  def index
    withdrawal_amount = Transaction.today.withdrawal.sum(:amount)
    enrollment_amount = Transaction.today.enrollment.sum(:amount)

    @top_managers_income =  -(withdrawal_amount + enrollment_amount)
    @parrots_with_negative_balance = Account.employee.joins(:balance).where('balances.amount < 0').count
    @most_expensive_task_amount_of_day = Task.completed_today.maximum(:amount)
    @most_expensive_task_amount_of_week = Task.completed_this_week.maximum(:amount)
    @most_expensive_task_amount_of_month = Task.completed_this_month.maximum(:amount)
  end
end
