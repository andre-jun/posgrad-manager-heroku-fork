module Admin
  class StudentsController < Admin::BaseController
    before_action :set_student, only: %i[edit update]

    def new
      @student = Student.new
      @user = User.new
    end

    def create
      ActiveRecord::Base.transaction do
        @user = User.new(user_params)

        @user.first_login = false
        @user.password = @user.nusp
        @user.password_confirmation = @user.nusp

        @user.save!

        @student = Student.new(student_params.merge(user: @user))
        @student.save!
      end

      redirect_to adm_home_path, notice: 'Aluno criado com sucesso!'
    rescue StandardError => e
      flash.now[:alert] = "Erro: #{e.message}"
      @student ||= Student.new(student_params)
      render :new, status: :unprocessable_entity
    end

    def edit
      @user = @student.user
    end

    def update
      @user = @student.user

      ActiveRecord::Base.transaction do
        @user.update!(user_params)
        @student.update!(student_params)
      end

      redirect_to adm_home_path, notice: 'Aluno atualizado!'
    rescue StandardError => e
      flash.now[:alert] = "Erro: #{e.message}"
      render :edit, status: :unprocessable_entity
    end

    private

    def set_student
      @student = Student.find(params[:id])
    end

    def student_params
      params.require(:student).permit(
        :program_level
      )
    end

    def user_params
      params.require(:user).permit(
        :name,
        :surname,
        :email,
        :nusp,
        :status
      )
    end
  end
end
