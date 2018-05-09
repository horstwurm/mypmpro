class AddFieldsToMobjects < ActiveRecord::Migration[5.0]
  def change
    add_column :mobjects, :color3, :string
    add_column :mobjects, :color4, :string
    add_column :mobjects, :claim, :string
    add_column :mobjects, :logo, :string
  end
end
