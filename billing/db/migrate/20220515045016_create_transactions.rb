class CreateTransactions < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE transaction_kinds AS ENUM ('enrollment', 'withdrawal', 'payment');
    SQL
    create_table :transactions do |t|
      t.references :account, null: false, foreign_key: true
      t.uuid :public_id, default: "gen_random_uuid()", null: false
      t.decimal :debit, default: 0
      t.decimal :credit, default: 0
      t.column :kind, :transaction_kinds, null: false

      t.timestamps
    end
  end

  def down
    drop_table :transactions
    execute <<-SQL
      DROP TYPE transaction_kinds;
    SQL
  end
end
