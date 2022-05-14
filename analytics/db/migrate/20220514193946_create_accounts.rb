class CreateAccounts < ActiveRecord::Migration[7.0]
  def change
    create_table :accounts do |t|
      t.string :full_name
      t.uuid :public_id
      t.string :email
      t.string :role

      t.timestamps
    end
  end
end
