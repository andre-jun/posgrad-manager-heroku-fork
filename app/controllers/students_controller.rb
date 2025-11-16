class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: %i[home show edit update change_professor]
  before_action :check_permissions, only: %i[home edit]
  before_action :find_professor, only: %i[change_professor]
  before_action :calculate_credits, only: %i[home]
  before_action :set_professor, only: %i[home]
  before_action :list_professors, only: %i[home]

  def navigation
    @student = Student.find(params[:id])

    respond_to do |format|
      format.html
      format.turbo_stream do
        render partial: "students/tabs/#{params[:tab] || 'profile'}", locals: { student: @student }
      end
    end
  end

  def home
    @reports = Report.where(id: @student.report_infos.pluck(:report_id)).all.order(year: :asc, semester: :asc)
  end

  def show
  end

  def change_professor
    return if ProfessorMentorsStudent.where(student: @student, professor: @professor).exists?

    ProfessorMentorsStudent.where(sutdent: @student).delete_all
    ProfessorMentorsStudent.create!(student: @student, professor: @professor)
  end

  def calculate_credits
    @courses = Course.where(id: TakesOnCourse.where(student: @student).pluck(:course_id))
    @credits = 0
    for course in @courses do
      @credits += course.credits if course.credits >= 0
    end
  end

  def edit
    return unless !@student.id == current_user.id

    redirect_to root_path, notice: "You're not the correct user to edit this."
  end

  def update
    if @student.update(student_params)
      redirect_to student_home_path, notice: 'Profile was successfully updated!'
    else
      render :edit
    end
  end

  def new
    @student = Student.new
  end

  def create
    @student = current_user.build_student(student_params)
    if @student.save
      @contact_info = ContactInfo.create!(user: @student.user)
      redirect_to root_path, notice: 'Student created!'
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @student.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_student
    @student = Student.find_by(params[:id])
  end

  def find_professor
    @professor = Professor.find_by(params[:professor_id])
  end

  def set_professor
    @professor = Professor.find_by(id: ProfessorMentorsStudent.where(student: @student).pluck(:professor_id))
  end

  def list_professors
    @professors = Professor.all.order(:name)
  end

  def student_params
    params.require(:student).permit(:name, :student_id, :role, :email, :lattes_link, :lattes_last_update,
                                    :pretended_career, :join_date,
                                    )
  end

  def check_permissions
    return if Student.where(user_id: current_user.id).exists?

    redirect_to root_path, notice: "You're not a student."
  end
end
