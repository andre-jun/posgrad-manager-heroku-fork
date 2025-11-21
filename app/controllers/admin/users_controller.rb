# app/controllers/admin/users_controller.rb
module Admin
  class UsersController < Admin::BaseController
    def index
      @users = User.all.order(:id)
    end

    def new
      @user = User.new
      build_role_record
    end

    def create
      @user = User.new(user_params)

      # set a temporary password so user can sign in and complete registration
      if @user.password.blank? && @user.nusp.present?
        @user.password = @user.nusp
        @user.password_confirmation = @user.nusp
      end

      # initially user hasn't completed registration
      @user.first_login = false

      if @user.save(validate: false) # we explicitly skip Devise validations if needed
        # If nested records exist, ensure they are saved with the user
        @user.reload
        redirect_to admin_users_path, notice: 'Usuário criado com sucesso'
      else
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @user = User.find(params[:id])
      build_role_record
    end

    def update
      @user = User.find(params[:id])

      # If admin edits and sets password, allow it
      if @user.update(user_params)
        redirect_to admin_users_path, notice: 'Usuário atualizado!'
      else
        render :edit, status: :unprocessable_entity
      end
    end

    private

    def build_role_record
      case params[:role] || @user_role_from_params
      when 'professor'
        @user.build_professor if @user.professor.nil?
      when 'student'
        @user.build_student if @user.student.nil?
      when 'administrator'
        @user.build_administrator if @user.administrator.nil?
      end
    end

    def user_params
      params.require(:user).permit(
        :name, :surname, :nusp, :status, :login_id,
        :email, :password, :password_confirmation,
        professor_attributes: %i[id department],
        student_attributes: %i[id program start_year],
        administrator_attributes: %i[id office]
      )
    end
  end
end
