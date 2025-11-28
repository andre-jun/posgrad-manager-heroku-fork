class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: %i[show edit update destroy]
  before_action :check_permissions, only: %i[new create]

  def export_pdf_view
    @student = Student.first
  end

  def show
    @report = Report.find(params[:id])

    @reports_pending = @report.report_infos.where(status: 'Draft')

    @reports_to_review = @report.report_infos.where(status: 'Sent')

    @reports_in_progress = @report.report_infos.where(status: 'Reviewed')

    @reports_done = @report.report_infos.where(status: 'Archived')
  end

  def index
    @reports = Report.order(year: :desc, semester: :desc)
  end

  def options
    @reports = Report.order(year: :desc, semester: :desc)
  end

  def new
    @report = Report.new
    @report.report_fields.build
  end

  def create
    @report = Report.new(report_params)

    if params[:commit] == 'Adicionar questão'
      @report.report_fields.build
      return render :new
    end

    if @report.save
      Student.find_each do |student|
        ReportInfo.create!(student: student, report: @report)
      end
      redirect_to adm_home_path, notice: 'Relatório criado com sucesso!'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @report.report_fields.build if @report.report_fields.empty?
  end

  def update
    if @report.update(report_params)
      redirect_to adm_home_path, notice: 'Relatório atualizado!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @report.destroy
    redirect_to adm_home_path, notice: 'Relatório removido!'
  end

  private

  def set_report
    @report = Report.find(params[:id])
  end

  def report_params
    params.require(:report).permit(
      :semester,
      :year,
      :due_date_student,
      :due_date_professor,
      :due_date_administrator,
      report_fields_attributes: %i[
        id question field_type required options _destroy
      ]
    )
  end

  def check_permissions
    return if current_user.administrator?

    redirect_to root_path, alert: 'Apenas administradores podem criar relatórios.'
  end
end
