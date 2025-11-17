class ReportsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_report, only: %i[ show edit update ]
  before_action :check_permissions, only: %i[ create ]

  def show
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
  end

  def create
    @report = current_user.build_report(report_params)
    if @report.save
      redirect_to root_path, notice: "report created!"
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @report.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_report
    @report = Report.find_by(params[:id])
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
