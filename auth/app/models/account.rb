class Account < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  after_create do
    event = {
      event_name: 'Auth.AccountCreated',
      data: {
        public_id: public_id,
        full_name: full_name,
        email: email,
        role: role
      }
    }

    WaterDrop::SyncProducer.call(event.to_json, topic: 'accounts-stream')
  end
end
