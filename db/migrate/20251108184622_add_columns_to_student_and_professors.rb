class AddColumnsToStudentAndProfessors < ActiveRecord::Migration[8.1]
  def change
    add_column :students, :semester, :integer, default: 0
    add_column :students, :credits, :integer, default: 0
    add_column :students, :credist_needed, :integer, default: 0
    add_column :professors, :department, :string

    add_reference :publications, :professor, foreign_key: true
  end
end
