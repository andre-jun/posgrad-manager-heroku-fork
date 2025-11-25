class DeleteCourses < ActiveRecord::Migration[8.1]
  def change
    drop_table :takes_on_courses
    drop_table :courses
    remove_column :students, :integer, :credits
    remove_column :students, :integer, :credits_needed
  end
end
