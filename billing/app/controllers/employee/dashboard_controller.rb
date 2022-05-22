module Employee
  class DashboardController < ApplicationController
    before_action :authenticate_account!
    before_action :authorize!

    def index
      @transactions = current_account.transactions.order(id: :desc)
    end

    private

    def authorize!
      return if current_account.employee?

      return redirect_to root_path if current_account.admin? || current_account.accountant?

      redirect_to login_path
    end
  end
end