class CreateTasks < ActiveRecord::Migration[7.0]
  def change
    create_table :tasks do |t|
      t.references :account, null: false, foreign_key: true
      t.uuid :public_id
      t.string :title
      t.string :jira_id
      t.string :description
      t.string :status
      t.decimal :amount, precision: 4, scale: 2
      t.decimal :fee, precision: 4, scale: 2

      t.timestamps
    end
  end
end
