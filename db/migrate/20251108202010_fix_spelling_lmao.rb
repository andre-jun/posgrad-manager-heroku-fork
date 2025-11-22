class FixSpellingLmao < ActiveRecord::Migration[8.1]
  def change
    rename_column :students, :credist_needed, :credits_needed
  end
end
