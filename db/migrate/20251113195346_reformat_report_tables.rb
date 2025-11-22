class ReformatReportTables < ActiveRecord::Migration[8.1]
  def change
    remove_column :reports, :coordinator_comments
    remove_column :reports, :review_date
    remove_column :reports, :reviewer
    remove_column :reports, :status
    remove_column :reports, :student_id
    remove_column :reports, :professor_comments
    remove_column :reports, :date_sent
    add_column :reports, :due_date_professor, :date
    add_column :reports, :due_date_student, :date
    add_column :reports, :due_date_administrator, :date

    create_table :report_info do |t|
      t.belongs_to :report, null: false, foreign_key: true
      t.belongs_to :student, null: false, foreign_key: true
      t.date :date_sent   # para saber se o aluno enviou dentro do prazo
      t.string :status, default: "Draft"
      t.string :owner, default: "Student"
      t.string :professor_comments
      t.string :coordinator_comments
      t.datetime :review_date
      t.integer :reviewer_id
      t.timestamps
    end
    add_foreign_key :report_info, :professors, column: :reviewer_id
    add_index :report_info, [ :report_id, :student_id ], unique: true

    
    create_table :report_fields do |t|
      t.belongs_to :report, null: false, foreign_key: true
      t.string :field_type, default: "Text"
      t.string :question, null: false
      t.string :options
      t.boolean :required, default: false
      t.timestamps
    end

    create_table :report_field_answers do |t|
      t.belongs_to :report, null: false, foreign_key: true
      t.belongs_to :report_fields, null: false, foreign_key: true
      t.string :answer
      t.timestamps
    end
  end
end
