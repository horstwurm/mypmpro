class AddFieldsToCompanyParams < ActiveRecord::Migration[5.0]
  def change
    add_column :company_params, :color3, :string
    add_column :company_params, :color4, :string
    add_column :company_params, :claim, :string
    add_column :company_params, :logo, :string
  end
end
