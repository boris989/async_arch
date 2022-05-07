class AccountsController < ApplicationController
  before_action :authenticate_account!

  def index
    @accounts = Account.all
  end

  def edit
  end

  def update
  end

  def destroy
  end

  private

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:full_name, :role)
  end
end
