class CreateTransactions < ActiveRecord::Migration[7.0]
  def change
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.uuid :public_id
      t.decimal :amount
      t.string :kind
      t.string :description

      t.timestamps
    end
  end
end
