class AccountsController < ApplicationController
  before_action :authenticate_account!, except: %i[current]
  before_action :set_account, only: %i[edit update destroy]

  def index
    @accounts = Account.all
  end

  def current
    render json: current_account
  end

  def edit
  end

  def update
    new_role = @account.role != account_params[:role] ? account_params[:role] : nil

    if @account.update(account_params)
      event = {
        event_name: 'Auth.AccountUpdated',
        data: {
          public_id: @account.public_id,
          email: @account.email,
          full_name: @account.full_name
        }
      }

      WaterDrop::SyncProducer.call(event.to_json, topic: 'accounts-stream')

      if new_role
        event = {
          event_name: 'Auth.AccountRoleChanged',
          data: {
            public_id: @account.public_id,
            role: @account.role
          }
        }
        WaterDrop::SyncProducer.call(event.to_json, topic: 'accounts')
      end
      redirect_to root_path, notice: 'Account was successfully updated.'
    else
      render :edit
    end
  end

  def destroy
    @account.update(active: false)
    event = {
      event_name: 'Auth.AccountDeleted',
      data: {
        public_id: @account.public_id
      }
    }

    WaterDrop::SyncProducer.call(event.to_json, topic: 'accounts-stream')

    redirect_to root_path, notice: 'Account was successfully destroyed.'
  end

  private

  def current_account
    if doorkeeper_token
      Account.find(doorkeeper_token.resource_owner_id)
    else
      super
    end
  end

  def set_account
    @account = Account.find(params[:id])
  end

  def account_params
    params.require(:account).permit(:full_name, :role)
  end
end
