class AddColsToMobjects < ActiveRecord::Migration[5.0]
  def change
    add_column :mobjects, :allow, :boolean
    add_column :mobjects, :allowdays, :integer
  end
end
