class AddonemoreColsToMobjects < ActiveRecord::Migration[5.0]
  def change
    add_column :mobjects, :sponsorenstatus, :string
  end
end
