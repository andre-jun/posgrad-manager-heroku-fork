module Admin
  class AdministratorsController < Admin::BaseController
    before_action :set_administrator, only: %i[edit update]

    def new
      @administrator = Administrator.new
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

        @administrator = Administrator.new(user: @user)
        @administrator.save!
      end

      redirect_to adm_home_path, notice: 'Administrador criado com sucesso!'
    rescue StandardError => e
      flash.now[:alert] = "Erro: #{e.message}"
      @administrator ||= Administrator.new
      render :new, status: :unprocessable_entity
    end

    def edit
      @user = @administrator.user
    end

    def update
      @user = @administrator.user

      ActiveRecord::Base.transaction do
        @user.update!(user_params)
      end

      redirect_to adm_home_path, notice: 'Administrador atualizado!'
    rescue StandardError => e
      flash.now[:alert] = "Erro: #{e.message}"
      render :edit, status: :unprocessable_entity
    end

    private

    def set_administrator
      @administrator = Administrator.find(params[:id])
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
