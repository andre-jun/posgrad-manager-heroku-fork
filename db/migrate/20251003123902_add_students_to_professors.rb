class AddStudentsToProfessors < ActiveRecord::Migration[7.1]
  def change
    add_reference :professors, :professor, null: false, foreign_key: true
  end
end
