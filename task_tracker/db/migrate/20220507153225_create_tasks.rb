class CreateTasks < ActiveRecord::Migration[7.0]
  def up
    execute <<-SQL
      CREATE TYPE task_statuses AS ENUM ('open', 'completed');
    SQL
    create_table :tasks do |t|
      t.references :account, null: false, foreign_key: true
      t.string :description
      t.column :status, :task_statuses, default: 'open'
      t.timestamps
    end
  end

  def down
    drop_table :tasks
    execute <<-SQL
      DROP TYPE task_statuses;
    SQL
  end
end
