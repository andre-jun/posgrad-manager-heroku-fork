class AdministratorsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_administrator, only: %i[ home show edit update ]
  before_action :check_permissions, only: %i[ home edit ]
  before_action :set_students, only: %i[ home export_pdf ]
  before_action :set_professors, only: %i[ home ]
  before_action :set_reports, only: %i[ home ]
  before_action :set_pending_reports, only: %i[ home ]
  before_action :new_user, only: %i[ home ]


  def home
  end

  def show
  end

  def new_user
    @new_user = User.new
  end

  def edit
    if !@administrator.id == current_user.id
      redirect_to root_path, notice: "You're not the correct user to edit this."
    end
  end

  def update
    if @administrator.update(administrator_params)
      redirect_to administrator_home_path, notice: "Profile was successfully updated!"
    else
      render :edit
    end
  end

  def new
    @administrator = Administrator.new
  end

  def create
    @administrator = current_user.build_Administrator(administrator_params)
    if @administrator.save
      redirect_to root_path, notice: "Administrator created!"
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @administrator.errors, status: :unprocessable_entity }
    end
  end

  def export_pdf
    respond_to do |format|
      format.html
      format.pdf do
        render pdf: "students_list",
              template: "reports/export_pdf",
              formats: [:html, :pdf],
              layout: false,
              page_size: "A4",
              margin: { top: 10, bottom: 10, left: 10, right: 10 },
              disposition: "attachment"
      end
    end
  end

  private

  def set_administrator
    # @administrator = Administrator.find_by(params[:id])
    @administrator = current_user.administrator
  end

  def set_students
    @students = Student.all
  end

  def set_professors
    @professors = Professor.all
  end

  def set_reports
    @reports = Report.all
  end

  def set_pending_reports
    @pending_reports = Report.where(owner: "Admin").where("due_date_administrator > ?", Date.today)

  end

  def check_permissions
    if !Administrator.where(user_id: current_user.id).exists?
      redirect_to root_path, notice: "You're not a administrator."
    end
  end

  def administrator_params
    params.require(:administrator).permit(:administrator_id)
  end
end
