module Auth
  class OauthSessionsController < ApplicationController
    def new
    end

    def create
      @account = Account.find_by(public_id: request.env['omniauth.auth']['public_id'])

      if @account
        session[:account_id] = @account.id
        redirect_to root_path
      else
        redirect_to login_path
      end
    end

    def destroy
    end
  end
end