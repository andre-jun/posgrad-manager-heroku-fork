class ProfessorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_professor, only: %i[home edit update]
  before_action :check_permissions, only: %i[home edit]
  before_action :set_students, only: %i[home]

  def student_info
    @student = Student.find(params[:id])

    respond_to do |format|
      format.turbo_stream do
        render turbo_stream: turbo_stream.replace(
          'student-info-panel',
          partial: 'professors/user_info/student_info',
          locals: { student: @student }
        )
      end
      format.html { redirect_to professor_path }
    end
  end

  def home
    @reports_due = Report.where(id: ReportInfo.where(owner: 'Professor', reviewer_id: @professor.id).pluck(:report_id))
    @next_due_date = @reports_due&.order(due_date_professor: :asc)&.first&.due_date_professor
    # tem que filtrar pro estudante especifico esse aqui de baixo V
    @report_due_student = Report.where(id: ReportInfo.where(owner: 'Student',
                                                            reviewer_id: @professor.id).pluck(:report_id))
    @next_due_date_student = @report_due_student&.order(due_date_student: :asc)&.first&.due_date_student
    # esse aqui tambem falta filtrar V
    @reproval_count = ReportInfo.where(student: Student.first,
                                       review_administrator: 'Adequado com Ressalvas' || 'Insatisfatório').count
  end

  def temp_report
    @report = ReportInfo.find(params[:id])
  end

  def show
    @professor = Professor.find(params[:id])
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

  def send_report
    @send = ReportInfo.find(params[:id])
    if @send.update(owner: 'Administrator', status: 'Review', review_date: Date.current)
      redirect_to professor_home_path, notice: 'Relatório avaliado!'
    else
      redirect_to professor_home_path, notice: 'Ocorreu algum erro e o relatório não pode ser avaliado.'
    end
  end

  def next_due_date
    # especificar que é DESTE professor
    return unless Report.any?

    @next_due_date = Report.all.order(due_date_professor: :asc).first.due_date_professor
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
    # estudantes que este professor orienta
    student_ids = ProfessorMentorsStudent.where(professor: @professor).pluck(:student_id)
    @students = Student.where(id: student_ids)
  end

  def check_permissions
    redirect_to root_path, notice: "You're not a professor." unless current_user.professor?
  end

  def professor_params
    params.require(:professor).permit(:research_area)
  end
end
