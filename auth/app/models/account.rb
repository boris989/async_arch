class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :access_grants,
           class_name: 'Doorkeeper::AccessGrant',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  has_many :access_tokens,
           class_name: 'Doorkeeper::AccessToken',
           foreign_key: :resource_owner_id,
           dependent: :delete_all # or :destroy if you need callbacks

  enum role: {
    admin: 'admin',
    manager: 'manager',
    employee: 'employee',
    accountant: 'accountant'
  }

  after_create do
    reload

    ProduceEvent.call(
      event_name: Events::ACCOUNT_CREATED,
      event_version: 1,
      schema: 'auth.account_created',
      topic: KafkaTopics::ACCOUNTS_STREAM,
      data: {
        public_id: public_id,
        full_name: full_name,
        email: email,
        role: role
      }
    )
  end
end
