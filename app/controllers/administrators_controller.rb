class AdministratorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_administrator, only: %i[home show edit update]
  before_action :check_permissions
  before_action :set_students, only: %i[home export_pdf]
  before_action :set_professors, only: %i[home]
  before_action :set_reports, only: %i[home]
  before_action :set_pending_reports, only: %i[home]

  def home
  end

  def show
  end

  def update
    if @administrator.update(administrator_params)
      redirect_to adm_home_path, notice: 'Profile was successfully updated!'
    else
      render :home, status: :unprocessable_entity
    end
  end

  # Exportar PDF com listas, relatórios etc.
  def export_pdf
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: 'students_list',
               template: 'reports/export_pdf',
               formats: %i[html pdf],
               layout: false,
               page_size: 'A4',
               margin: { top: 10, bottom: 10, left: 10, right: 10 },
               disposition: 'attachment'
      end
    end
  end

  def send_report
    @send = ReportInfo.find(params[:id])
    if @send.update(owner: "Student", status: "Archived")
      redirect_to adm_home_path, notice: 'Relatório avaliado!'
    else
      redirect_to adm_home_path, notice: 'Ocorreu algum erro e o relatório não pode ser avaliado.'
    end
  end

  private

  def set_administrator
    @administrator = current_user.administrator
  end

  def check_permissions
    redirect_to root_path, notice: "You're not an administrator." unless current_user.administrator?
  end

  def set_students
    @students = Student.all
  end

  def set_professors
    @professors = Professor.all
  end

  def set_reports
    @reports = Report.all.order(year: :desc, semester: :desc)
  end

  def set_pending_reports
    @pending_reports = Report.where(owner: 'Admin').where('due_date_administrator > ?', Date.today)
  end
end
