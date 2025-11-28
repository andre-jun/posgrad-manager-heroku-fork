require 'zip'

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
      redirect_to adm_home_path, notice: 'Perfil foi atualizado com sucesso!'
    else
      render :home, status: :unprocessable_entity
    end
  end


  def send_report
    @send = ReportInfo.find(params[:id])
    if @send.update(status: 'Archived')
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
    redirect_to root_path, notice: 'Você não é um administrador.' unless current_user.administrator?
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

  # receiving a list of files, zip them and place in zip_name
  def compile_reports_to_zip(files, zip_output)
    zip_file = Temfile.new(zip_output)

    Zip::OutputStream.open(zip_file) do |zos|
      files.each do |file_path|
        # 3. Add an entry to the zip file
        zos.put_next_entry(File.basename(file_path))
        # 4. Write the file's content to the entry
      end
    end

    zip_file.close
    zip_file.unlink
  end

  def set_pending_reports
    @pending_reports = Report.where(status: 'Reviewed').where('due_date_administrator > ?', Date.today)
  end
end
