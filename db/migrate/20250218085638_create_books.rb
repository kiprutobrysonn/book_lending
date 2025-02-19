class CreateBooks < ActiveRecord::Migration[8.0]
  def change
    create_table :books do |t|
      t.string :title
      t.string :author
      t.string :isbn
      t.string :description
      t.string :publisher
      t.string :publication_year
      t.string :language

      t.timestamps
    end
    add_index :books, :isbn, unique: true
  end
end
