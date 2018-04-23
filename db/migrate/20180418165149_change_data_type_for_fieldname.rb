class ChangeDataTypeForFieldname < ActiveRecord::Migration[5.0]
  def change
    change_column :mobjects, :sponsorenperiode, :string
  end
end
