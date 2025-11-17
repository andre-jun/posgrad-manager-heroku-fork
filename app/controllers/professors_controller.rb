class ProfessorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_professor, only: %i[home show edit update]
  before_action :check_permissions, only: %i[home edit]
  before_action :next_due_date, only: %i[home]
  before_action :set_students, only: %i[home calculate_reports_due]
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
    return unless !@professor.id == current_user.id

    redirect_to root_path, notice: "You're not the correct user to edit this."
  end

  def update
    if @professor.update(professor_params)
      redirect_to professor_home_path, notice: 'Profile was successfully updated!'
    else
      render :edit
    end
  end

  def new
    @professor = Professor.new
  end

  def create
    @professor = current_user.build_professor(professor_params)
    if @professor.save
      redirect_to root_path, notice: 'Professor created!'
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @professor.errors, status: :unprocessable_entity }
    end
  end

  def next_due_date
    # especificar que é DESTE professor
    @next_due_date = Report.all.order(due_date_professor: :asc).first&.due_date_professor
  end

  def calculate_reports_due
    # é due pra esse professor fazer ou os estudantes que tão devendo??
    # trocar owner?
    @reports_due = Report.where(owner: 'Professor',
                                id: ReportInfo.where(reviewer_id: Professor.first.id).pluck(:report_id))
  end

  private

  def set_professor
    # @professor = Professor.find_by(params[:id])
    @professor = current_user.professor
  end

  def set_students
    # change to students related to the professor
    @students = Student.where(id: ProfessorMentorsStudent.where(professor: @professor).pluck(:student_id))
  end

  def check_permissions
    return if Professor.where(user_id: current_user.id).exists?

    redirect_to root_path, notice: "You're not a professor."
  end

  def professor_params
    params.require(:professor).permit(:name, :professor_id, :research_area)
  end
end
