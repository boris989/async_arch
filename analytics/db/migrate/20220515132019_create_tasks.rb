class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :account, null: false, foreign_key: true
      t.uuid :public_id
      t.string :title
      t.string :jira_id
      t.string :description
      t.decimal :amount
      t.decimal :fee
      t.string :status
      t.datetime :completed_at

      t.timestamps
    end
  end
end
