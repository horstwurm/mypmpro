class AddColumnsToMDetails < ActiveRecord::Migration[5.0]
  def change
    add_column :mdetails, :video_file_name, :string
    add_column :mdetails, :video_content_type, :string
    add_column :mdetails, :video_file_size, :integer
    add_column :mdetails, :video_updated_at, :datetime
  end
end
