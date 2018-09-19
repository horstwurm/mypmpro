class CreatePplans < ActiveRecord::Migration[5.0]
  def change
    create_table :pplans do |t|
      t.integer :mobject_id
      t.integer :version
      t.string :version_name
      t.string :task
      t.date :date_from
      t.date :date_to
      t.string :tasktype
      t.integer :position
      t.integer :poc
      t.timestamps
    end
  end
end
