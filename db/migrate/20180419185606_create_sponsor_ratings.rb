class CreateSponsorRatings < ActiveRecord::Migration[5.0]
  def change
    create_table :sponsor_ratings do |t|
      t.integer :user_id
      t.integer :mobject_id
      t.text :descriptions
      t.float :amount
      t.boolean :decision

      t.timestamps
    end
  end
end
