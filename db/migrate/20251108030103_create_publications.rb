class CreatePublications < ActiveRecord::Migration[8.1]
  def change
    create_table :publications do |t|
      t.string :name
      t.string :abstract
      t.string :link
      t.date :publication_date
      t.belongs_to :student, null: false, foreign_key: true

      t.timestamps
    end
  end
end
