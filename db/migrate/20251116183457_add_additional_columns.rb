class AddAdditionalColumns < ActiveRecord::Migration[8.1]
  def change
    add_column :users, :pronoun, :string
    
    create_table :contact_infos do |t|
      t.belongs_to :users, null: false, foreign_key: true
      t.string :phone_number
      t.string :room_number
      t.timestamps
    end
  end
end

