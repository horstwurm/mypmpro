class CreateMvdetails < ActiveRecord::Migration[5.0]
  def change
    create_table :mvdetails do |t|
      t.integer :mobject_id
      t.string :name
      t.text :description
      t.integer :sequence
      t.string :video_file_name
      t.string :video_content_type
      t.integer :video_file_size
      t.datetime :video_updated_at

      t.timestamps
    end
  end
end
