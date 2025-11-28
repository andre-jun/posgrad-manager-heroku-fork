class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?

  def root_redirect
    return redirect_to new_user_session_path unless user_signed_in?

    return redirect_to complete_registration_path unless current_user.first_login?

    if current_user.administrator?
      redirect_to adm_home_path
    elsif current_user.professor?
      redirect_to professor_home_path
    elsif current_user.student?
      redirect_to student_home_path
    else
      raise "Usuário #{current_user.id} não tem um papel válido (administrador/professor/aluno)!"
    end
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
  end
end
