class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: %i[ show edit update destroy ]
  before_action :check_permissions, only: %i[ create ]

  def show
    @reports_done = @report.report_infos.where(owner: "Administrator")  # add "ou archived" pra filtrar melhor
    @reports_pending = @report.report_infos.excluding(@reports_done).where.not(status: "Archived")  # aí da pra remover esse .where.not()
  end

  def index
    @reports = Report.all.order(year: :desc, semester: :desc)
  end

  def edit
  end

  def update
    if @report.update(report_params)
      redirect_to adm_home_path, notice: "Report was successfully updated!"
    else
      render :edit
    end
  end

  def new
    @report = Report.new
  end
  
  def create
    @report = Report.create(report_params)
    if @report.save
      redirect_to adm_home_path, notice: "report created!"
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @report.errors, status: :unprocessable_entity }
    end
  end

  def copy_and_create
    @old_report = Report.find_by(params[:id])
    @new_report = @old_report.deep_clone include: [ :report_fields ]
    if @new_report.save
      redirect_to edit_report_path(@new_report), notice: "Relatório clonado!"
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @new_report.errors, status: :unprocessable_entity }
    end
  end

  def report_answers
    @report = ReportInfo.find_by(params[:report_info])
    @r_answers = @report.report_field_answers
    # só retorna as não respondidas que são obrigatórias. as opcionais não importa
    @r_unanswereds = @report.report.report_fields.excluding((@r_answers.includes(:report_field).map(&:report_field))).where(required: true)
  end

  # por enquanto fica dando "FOREIGN KEY constraint failed" n sei pq T_T
  def destroy
    @report.destroy!

    respond_to do |format|
      format.html { redirect_to adm_home_path, notice: "Report was successfully destroyed.", status: :see_other }
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
                                    report_fields_attributes: [ :id, :field_type, :question, :required, :options ] )
  end

  def check_permissions
    if !Student.where(user_id: current_user.id).exists?
      redirect_to root_path, notice: "You're not a student."
    end
  end
end
