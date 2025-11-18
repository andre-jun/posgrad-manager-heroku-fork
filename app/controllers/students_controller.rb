class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: %i[home show edit update change_professor]
  before_action :check_permissions, only: %i[home edit]
  before_action :calculate_credits, only: %i[home]
  before_action :set_professor, only: %i[home]
  before_action :list_professors, only: %i[home]

  def navigation
    respond_to do |format|
      format.html
      format.turbo_stream do
        render partial: "students/tabs/#{params[:tab] || 'profile'}",
               locals: { student: @student }
      end
    end
  end

  def home
    @reports = Report.where(id: @student.report_infos.pluck(:report_id)).all.order(year: :asc, semester: :asc)
    @pending_report = @student.report_infos.where(owner: 'Student').order(created_at: :asc).last
  end

  def show
  end

  def change_professor
    return if ProfessorMentorsStudent.where(student: @student, professor: @professor).exists?

    ProfessorMentorsStudent.where(student: @student).delete_all
    ProfessorMentorsStudent.create!(student: @student, professor: @professor)
  end

  def calculate_credits
    @courses = Course.where(id: TakesOnCourse.where(student: @student).pluck(:course_id))
    @credits = @courses.sum { |course| course.credits.to_i }
  end

  def edit
    redirect_to root_path, notice: "You're not authorized." unless @student.user == current_user
  end

  def update
    if @student.update(student_params)
      redirect_to student_home_path, notice: 'Profile was successfully updated!'
    else
      render :edit
    end
  end

  private

  def set_student
    @student = current_user.student
  end

  def set_professor
    professor_id = ProfessorMentorsStudent.where(student: @student).pluck(:professor_id).first
    @professor = Professor.find_by(id: professor_id)
  end

  def list_professors
    @professors = Professor.all.order(:name)
  end

  def student_params
    params.require(:student).permit(:lattes_link, :lattes_last_update, :pretended_career, :join_date)
  end

  def check_permissions
    redirect_to root_path, notice: "You're not a student." unless current_user.student?
  end
end
