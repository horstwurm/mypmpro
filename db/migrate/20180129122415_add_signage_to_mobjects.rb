class AddSignageToMobjects < ActiveRecord::Migration[5.0]
  def change
    add_column :mobjects, :signage, :boolean
  end
end
