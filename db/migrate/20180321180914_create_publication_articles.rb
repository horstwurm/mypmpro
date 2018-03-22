class CreatePublicationArticles < ActiveRecord::Migration[5.0]
  def change
    create_table :publication_articles do |t|
      t.integer :publication
      t.integer :article
      t.string :status
      t.boolean :active
      t.integer :sequence

      t.timestamps
    end
  end
end
