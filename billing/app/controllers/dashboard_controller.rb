class DashboardController < ApplicationController
  before_action :authenticate_account!
  before_action :authorize!

  def index
    @withdrawal_amount = BillingCycle.current.transactions.withdrawal.sum(:credit)
    @enrollment_amount = BillingCycle.current.transactions.enrollment.sum(:debit)

    @top_managers_income =  -(@withdrawal_amount + @enrollment_amount)
  end

  def close_billing_cycle_and_open_new
    @payment_transactions = []
    BillingCycle.transaction do
      Account.employee.includes(:balance).each do |account|
        next if account.balance.amount <= 0

        @payment_transactions << account.transactions.payment.create!(
          credit: account.balance.amount,
          debit: 0,
          billing_cycle: BillingCycle.current
        )
      end

      BillingCycle.current.update!(status: 'closed')

      BillingCycle.create!
    end

    @payment_transactions.each do |transaction|
      puts "Send payment amount #{transaction.amount} to email #{transaction.account.email}"

      event = {
        event_name: Events::EMPLOYEE_PAYMENT_MADE,
        data: {
          employee_public_id: transaction.account.public_id,
          debit: transaction.debit,
          credit: transaction.credit,
          payment_at: transaction.created_at
        }
      }

      WaterDrop::SyncProducer.call(event.to_json, topic: KafkaTopics::EMPLOYEE_PAYMENTS)
    end

    redirect_to root_path, notice: 'Billing cycle successfully closed and new opened.'
  end

  private

  def authorize!
    return if current_account.admin? || current_account.accountant?

    return redirect_to employee_dashboard_path if current_account.employee?

    redirect_to login_path
  end
end
