class ReportInfosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report_info,
                only: %i[edit update show professor_submit_review submit_review administrator_submit_review
                         submit_admin_review]
  before_action :ensure_student_access, only: %i[edit update]
  before_action :ensure_professor_access, only: %i[professor_submit_review]

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
        'Sent'
      else
        @report_info.status
      end

    if @report_info.update(report_info_params.merge(status: status))
      redirect_to student_home_path, notice: 'Relatório atualizado com sucesso!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def professor_submit_review
    @report = @report_info.report
    @student = @report_info.student
    @answers = @report_info.report_field_answers.includes(:report_field)
  end

  def administrator_submit_review
    @report_info = ReportInfo.find(params[:id])
  end

  def submit_review
    if @report_info.update(
      review_professor: params[:report_info][:review_professor],
      professor_comments: params[:report_info][:professor_comments],
      review_date: Time.current,
      reviewer_id: current_user.professor.id,
      status: 'Reviewed'
    )
      redirect_to report_info_path(@report_info), notice: 'Avaliação enviada com sucesso!'
    else
      redirect_to professor_submit_review_report_info_path(@report_info), alert: 'Erro ao enviar avaliação.'
    end
  end

  def submit_admin_review
    if @report_info.update(
      review_administrator: params[:report_info][:review_administrator],
      coordinator_comments: params[:report_info][:coordinator_comments],
      status: 'Archived'
    )
      redirect_to report_info_path(@report_info), notice: 'Avaliação do administrador enviada com sucesso!'
    else
      redirect_to administrator_submit_review_report_info_path(@report_info), alert: 'Erro ao enviar avaliação.'
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

  def ensure_professor_access
    return if current_user.professor?

    redirect_to root_path, alert: 'Você não tem permissão para avaliar este relatório.'
  end

  def report_info_params
    params.require(:report_info).permit(
      :status,
      report_field_answers_attributes: %i[id report_field_id answer]
    )
  end
end
