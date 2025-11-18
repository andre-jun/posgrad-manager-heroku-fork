module Admin
  class ProfessorsController < Admin::BaseController
    before_action :set_professor, only: %i[edit update]

    def new
      @professor = Professor.new
      @user = User.new
    end

    def create
      ActiveRecord::Base.transaction do
        @user = User.new(user_params)

        if @user.password.blank?
          @user.password = @user.nusp
          @user.password_confirmation = @user.nusp
        end

        @user.save!

        @professor = Professor.new(professor_params.merge(user: @user))
        @professor.save!
      end

      redirect_to adm_home_path, notice: 'Professor criado com sucesso!'
    rescue StandardError => e
      flash.now[:alert] = "Erro: #{e.message}"
      @professor ||= Professor.new(professor_params)
      render :new, status: :unprocessable_entity
    end

    def edit
      @user = @professor.user
    end

    def update
      @user = @professor.user

      ActiveRecord::Base.transaction do
        @user.update!(user_params)
        @professor.update!(professor_params)
      end

      redirect_to adm_home_path, notice: 'Professor atualizado!'
    rescue StandardError => e
      flash.now[:alert] = "Erro: #{e.message}"
      render :edit, status: :unprocessable_entity
    end

    private

    def set_professor
      @professor = Professor.find(params[:id])
    end

    def professor_params
      params.require(:professor).permit(
        :research_area,
        :department,
        :professor_id,
        :user_id,
        :publications_count,
        :students_count
      )
    end

    def user_params
      params.require(:user).permit(
        :name,
        :surname,
        :email,
        :nusp,
        :pronoun,
        :status,
        :password,
        :password_confirmation
      )
    end
  end
end
