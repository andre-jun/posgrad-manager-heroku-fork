module Admin
  class AdministratorsController < Admin::BaseController
    before_action :set_administrator, only: %i[edit update destroy]

    def index
      @administrators = Administrator.includes(user: :professor)
    end

    def new
      @administrator = Administrator.new
      load_professors
    end

    def create
      professor = Professor.find(admin_params[:professor_id])
      user = professor.user

      @administrator = Administrator.new(user: user)

      if @administrator.save
        redirect_to adm_home_path, notice: 'Administrador criado com sucesso!'
      else
        load_professors
        flash.now[:alert] = @administrator.errors.full_messages.to_sentence
        render :new, status: :unprocessable_entity
      end
    end

    def edit
      @user = @administrator.user
    end

    def update
      if @administrator.update(update_params)
        redirect_to adm_home_path, notice: 'Administrador atualizado!'
      else
        flash.now[:alert] = @administrator.errors.full_messages.to_sentence
        render :edit, status: :unprocessable_entity
      end
    end

    def destroy
      @administrator.destroy
      redirect_to adm_home_path, notice: 'Administrador removido com sucesso!'
    rescue StandardError => e
      redirect_to adm_home_path, alert: "Erro ao remover administrador: #{e.message}"
    end

    private

    def set_administrator
      @administrator = Administrator.find(params[:id])
    end

    def load_professors
      current_admin_user_ids = Administrator.pluck(:user_id)
      @professors = Professor.includes(:user)
                             .where.not(user_id: current_admin_user_ids)
    end

    def admin_params
      params.require(:administrator).permit(:professor_id)
    end

    def update_params
      params.require(:administrator).permit
    end
  end
end
