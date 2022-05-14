class DashboardController < ApplicationController
  before_action :authenticate_account!
  before_action :authorize!

  def index
  end

  private

  def authorize!
    return if current_account.admin? || current_account.accountant?

    return redirect_to employee_dashboard_path if current_account.employee?

    redirect_to login_path
  end
end
