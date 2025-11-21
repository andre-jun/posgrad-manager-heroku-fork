class ApplicationController < ActionController::Base
  before_action :configure_permitted_parameters, if: :devise_controller?
  before_action :check_first_login

  private

  def check_first_login
    return unless user_signed_in?

    return if params[:controller].start_with?('admin/')

    return if devise_controller?

    return if %w[complete_registrations complete_registration].include?(params[:controller])

    return if current_user.first_login?

    redirect_to complete_registration_path
  end

  protected

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_in, keys: [:login])
  end
end
