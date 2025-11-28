class StudentsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_student, only: %i[home edit update change_professor]
  before_action :check_permissions, only: %i[home edit]
  before_action :set_professor, only: %i[home]
  before_action :list_professors, only: %i[home]

  def navigation
    respond_to do |format|
      format.html
      format.turbo_stream do
        render partial: "students/tabs/#{params[:tab] || 'report'}",
               locals: { student: @student }
      end
    end
  end

  def home
    @reports = @student.reports.order(year: :asc, semester: :asc)

    @pending_report_info = @student.report_infos
                                   .where(status: 'Draft')
                                   .order(created_at: :asc)
                                   .last

    @pending_report = @pending_report_info&.report

    return unless @pending_report_info && @pending_report

    @pending_report.report_fields.each do |field|
      @pending_report_info.report_field_answers.find_or_initialize_by(report_field_id: field.id)
    end
  end

  def show
    @student = Student.find_by(params[:id])
  end

  def change_professor
    return if ProfessorMentorsStudent.where(student: @student, professor: @professor).exists?

    ProfessorMentorsStudent.where(student: @student).delete_all
    ProfessorMentorsStudent.create!(student: @student, professor: @professor)
  end

  def send_report
    @send = ReportInfo.find(params[:id])
    if @send.update(owner: 'Professor', date_sent: Date.current, status: 'Sent')
      redirect_to student_home_path, notice: 'Relatório enviado!'
    else
      redirect_to student_home_path, notice: 'Ocorreu algum erro e o relatório não pode ser enviado.'
    end
  end

  def edit
    redirect_to root_path, notice: 'Você não possui autorização para essa ação.' unless @student.user == current_user
  end

  def update
    if @student.update(student_params)
      redirect_to student_home_path, notice: 'Perfil atualizado com sucesso!'
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
    params.require(:student).permit(:name, :student_id, :role, :email, :lattes_link, :lattes_last_update,
                                    :pretended_career, :join_date)
  end

  def check_permissions
    redirect_to root_path, notice: 'Você não é um aluno.' unless current_user.student?
  end
end
