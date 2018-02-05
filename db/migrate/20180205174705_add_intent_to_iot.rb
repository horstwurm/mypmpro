class AddIntentToIot < ActiveRecord::Migration[5.0]
  def change
    add_column :iots, :intent, :string
  end
end
