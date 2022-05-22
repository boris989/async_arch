class CreateBalances < ActiveRecord::Migration[7.0]
  def change
    create_table :balances do |t|
      t.references :account, null: false, foreign_key: true
      t.decimal :amount, default: 0

      t.timestamps
    end
  end
end
