module Admin
  class BaseController < ApplicationController
    before_action :authenticate_user!
    skip_before_action :check_first_login

    before_action :ensure_admin!

    private

    def ensure_admin!
      redirect_to root_path, alert: 'Acesso negado' unless current_user&.administrator?
    end
  end
end
