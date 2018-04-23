class AddmoreColsToMobjects < ActiveRecord::Migration[5.0]
  def change
    add_column :mobjects, :sponsorenart, :integer
    add_column :mobjects, :sponsorenperiode, :integer
    add_column :mobjects, :sponsorenbetragantrag, :float
    add_column :mobjects, :sponsorenbetraggenehmigt, :float
    add_column :mobjects, :sponsorenantwort, :text
    add_column :mobjects, :sponsorenok, :boolean
  end
end
