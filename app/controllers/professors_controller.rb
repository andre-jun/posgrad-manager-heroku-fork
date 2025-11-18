class ProfessorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_professor, only: %i[home show edit update]
  before_action :check_permissions, only: %i[home edit]
  before_action :next_due_date, only: %i[home]
  before_action :set_students, only: %i[home]
  before_action :calculate_reports_due, only: %i[home]

  def student_info
    @student = Student.find(params[:id])
    render partial: 'professors/user_info/student_info', locals: { student: @student }
  end

  def home
  end

  def show
  end

  def edit
    redirect_to root_path, notice: "You're not authorized." unless @professor.user == current_user
  end

  def update
    if @professor.update(professor_params)
      redirect_to professor_home_path, notice: 'Profile was successfully updated!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_professor
    # @professor = Professor.find_by(params[:id])
    @professor = current_user.professor
  end

  def set_students
    # estudantes que este professor orienta
    student_ids = ProfessorMentorsStudent.where(professor: @professor).pluck(:student_id)
    @students = Student.where(id: student_ids)
  end

  def check_permissions
    redirect_to root_path, notice: "You're not a professor." unless current_user.professor?
  end

  def next_due_date
    # próximo relatório do professor
    # @next_due_date = Report.where(owner: 'Professor', reviewer_id: @professor.id)
    #                      .order(due_date_professor: :asc)
    #                      .first&.due_date_professor
  end

  def calculate_reports_due
    @reports_due = Report.where(owner: 'Professor',
                                id: ReportInfo.where(reviewer_id: @professor.id).pluck(:report_id))
  end

  def professor_params
    params.require(:professor).permit(:research_area)
  end
end
