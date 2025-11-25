class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: %i[show edit update destroy]
  before_action :check_permissions, only: %i[create]

  def show
    if current_user.administrator?
      @reports_done = @report.report_infos # add "ou archived" pra filtrar melhor
      @reports_to_review = @reports_done.where(owner: 'Administrator', review_administrator: 'Pendente')
      @reports_in_progress = @reports_done.where(review_professor: 'Pendente')
      @reports_pending = @report.report_infos.excluding(@reports_to_review).where(status: 'Draft') # aí da pra remover esse .where.not()
    elsif current_user.professor?
      # por enquanto igual
      @reports_done = @report.report_infos.where(owner: 'Administrator')
      @reports_pending = @report.report_infos.excluding(@reports_done).where.not(status: 'Archived')
    else
      redirect_to student_show_path
    end
  end

  def student_show
    @report = Report.find_by(params[:id])
    # esse aqui assume que não da pra ter enviado >1 pro mesmo relatorio (pelo menos n deveria dar)
    @report_info = @report.report_infos.where(student: current_user.student).first
    @r_answers = ReportFieldAnswer.where(report_info: @report_info)
  end

  def index
    @reports = Report.all.order(year: :desc, semester: :desc)
  end

  def edit
    @report.report_fields.build if @report.report_fields.empty?
  end

  def update
    if @report.update(report_params)
      redirect_to adm_home_path, notice: 'Report was successfully updated!'
    else
      render :edit
    end
  end

  def new
    @report = Report.new
    @report.report_fields.build
  end

  def create
    @report = Report.create(report_params)
    if @report.save
      redirect_to adm_home_path, notice: 'report created!'
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @report.errors, status: :unprocessable_entity }
    end
  end

  def copy_and_create
    @old_report = Report.find_by(params[:id])
    @new_report = @old_report.deep_clone include: [:report_fields]
    if @new_report.save
      redirect_to edit_report_path(@new_report), notice: 'Relatório clonado!'
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @new_report.errors, status: :unprocessable_entity }
    end
  end

  def report_answers
    @report = ReportInfo.find_by(params[:report_info])
    @r_answers = @report.report_field_answers
    # só retorna as não respondidas que são obrigatórias. as opcionais não importa
    @r_unanswereds = @report.report.report_fields.excluding(@r_answers.includes(:report_field).map(&:report_field)).where(required: true)
  end

  # por enquanto fica dando "FOREIGN KEY constraint failed" n sei pq T_T
  def destroy
    @report.destroy!

    respond_to do |format|
      format.html { redirect_to adm_home_path, notice: 'Report was successfully destroyed.', status: :see_other }
      format.json { head :no_content }
    end
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  # TODO: edit these + add other report controllers
  def report_params
    params.require(:report).permit(:report_id, :semester, :year, :owner, :due_date_professor, :due_date_student, :due_date_administrator,
                                   report_fields_attributes: %i[id field_type question required options])
  end

  def check_permissions
    return if Student.where(user_id: current_user.id).exists?

    redirect_to root_path, notice: "You're not a student."
  end
end
