class AddDescriptionToTransaction < ActiveRecord::Migration[7.0]
  def change
    add_column :transactions, :description, :string
  end
end
