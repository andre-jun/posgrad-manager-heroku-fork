class RemoveStudentIdFromStudent < ActiveRecord::Migration[8.1]
  def change
    remove_column :students, :student_id, :integer
    remove_column :professors, :professor_id, :integer
  end
end
