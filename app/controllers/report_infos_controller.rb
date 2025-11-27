class ReportInfosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report_info, only: %i[edit update show]
  before_action :ensure_student_access, only: %i[edit update]

  def show
    @report_info = ReportInfo.find(params[:id])
    @report = @report_info.report
    @answers = @report_info.report_field_answers.includes(:report_field)
    @student = @report_info.student
  end

  def edit
    existing_ids = @report_info.report_field_answers.pluck(:report_field_id)
    @report_info.report.report_fields.where.not(id: existing_ids).each do |field|
      @report_info.report_field_answers.build(report_field: field)
    end
  end

  def update
    status =
      case params[:commit]
      when 'save_draft'
        'Draft'
      when 'submit'
        'Submitted'
      else
        @report_info.status
      end

    if @report_info.update(report_info_params.merge(status: status))
      redirect_to student_home_path, notice: 'Relatório atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_report_info
    @report_info = ReportInfo.find(params[:id])
  end

  def ensure_student_access
    return if current_user.student? && current_user.student.id == @report_info.student_id

    redirect_to root_path, alert: 'Você não tem permissão para editar este relatório.'
  end

  def report_info_params
    params.require(:report_info).permit(
      :status,
      report_field_answers_attributes: %i[id report_field_id answer]
    )
  end
end
