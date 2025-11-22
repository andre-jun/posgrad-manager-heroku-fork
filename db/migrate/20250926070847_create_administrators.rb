class CreateAdministrators < ActiveRecord::Migration[7.1]
  def change
    create_table :administrators do |t|
      t.string :name
      t.string :role
      t.timestamps
    end
  end
end
