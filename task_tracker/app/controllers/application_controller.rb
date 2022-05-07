class ApplicationController < ActionController::Base
  def authenticate_account!
    @account = Account.find_by(id: session[:account_id])

    redirect_to login_path unless @account
  end
end
