class CreateNotes < ActiveRecord::Migration[5.0]
  def change
    create_table :notes do |t|
      t.integer :user_id
      t.date :datum
      t.integer :uhrzeit
      t.text :message

      t.timestamps
    end
  end
end
