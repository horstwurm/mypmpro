class AddsvalueToSensors < ActiveRecord::Migration[5.0]
  def change
    add_column :sensors, :svalue, :string
    add_column :sensors, :bvalue, :boolean
  end
end
