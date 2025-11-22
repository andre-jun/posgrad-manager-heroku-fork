class CreateAdditionalColumnsAndTables < ActiveRecord::Migration[8.1]
  def change
    add_reference :reports, :student, foreign_key: true
    add_column :reports, :status, :string
    add_column :reports, :professor_comments, :string
    add_column :reports, :coordinator_comments, :string
    add_column :reports, :review_date, :datetime
    add_column :reports, :reviewer, :string

    create_table :professor_mentors_students do |t|
      t.integer :professor_id, null: false 
      t.integer :student_id, null: false
      t.timestamps
    end
    add_index :professor_mentors_students, [ :professor_id, :student_id ], unique: true

    create_table :courses do |t|
      t.string :name
      t.references :professor, null: false, foreign_key: true
      t.integer :credits
      t.timestamps
    end

    create_table :takes_on_courses do |t|
      t.string :grade
      t.integer :course_id, null: false
      t.integer :student_id, null: false
      t.timestamps
    end
    add_index :takes_on_courses, [ :course_id, :student_id ], unique: true
  end
end
