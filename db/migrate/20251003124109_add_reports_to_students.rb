class AddReportsToStudents < ActiveRecord::Migration[7.1]
  def change
    add_reference :students, :student, null: false, foreign_key: true
  end
end
