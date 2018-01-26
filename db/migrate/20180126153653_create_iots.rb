class CreateIots < ActiveRecord::Migration[5.0]
  def change
    create_table :iots do |t|
      t.integer :owner_id
      t.string :owner_type
      t.string :name
      t.float :value

      t.timestamps
    end
  end
end
