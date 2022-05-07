class ApplicationController < ActionController::Base
  def authenticate_account!
    redirect_to login_path unless current_account
  end

  def current_account
    return if session[:account_id].blank?

    @current_account ||= Account.find_by(id: session[:account_id])
  end

  def account_signed_in?
    current_account.present?
  end

  helper_method :account_signed_in?, :current_account
end
