class AddColumnsToMobjects < ActiveRecord::Migration[5.0]
  def change
    add_column :mobjects, :requester_id, :integer
    add_column :mobjects, :requester_type, :string
  end
end
