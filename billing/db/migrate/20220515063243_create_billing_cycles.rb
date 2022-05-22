class CreateBillingCycles < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE billing_cycle_statuses AS ENUM ('open', 'closed');
    SQL
    create_table :billing_cycles do |t|
      t.column :status, :billing_cycle_statuses, default: 'open', null: false

      t.timestamps
    end
  end

  def down
    drop_table :billing_cycles
    execute <<-SQL
      DROP TYPE billing_cycle_statuses;
    SQL
  end
end
