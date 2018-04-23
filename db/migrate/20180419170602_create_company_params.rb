class CreateCompanyParams < ActiveRecord::Migration[5.0]
  def change
    create_table :company_params do |t|
      t.integer :company_id
      t.string :sponsoring_wert1
      t.string :sponsoring_wert2
      t.string :sponsoring_wert3
      t.string :sponsoring_wert4
      t.string :sponsoring_wert5
      t.text :sponsoring_init
      t.text :sponsoring_ok
      t.text :sponsoring_ok_change
      t.text :sponsoring_nok
      t.string :role_company
      t.string :role_sponsoring
      t.string :color1
      t.string :color2
      t.timestamps
    end
  end
end
