class CompleteRegistrationsController < ApplicationController
  before_action :authenticate_user!
  before_action :redirect_if_completed

  def show
    @user = current_user
    @user.build_professor if @user.professor.nil? && params[:role] == 'professor'
    @user.build_student if @user.student.nil? && params[:role] == 'student'

    respond_to do |format|
      format.html
    end
  end

  def update
    @user = current_user

    if @user.update(complete_params.merge(first_login: true))
      redirect_to root_path, notice: 'Cadastro completo'
    else
      render :show, status: :unprocessable_entity
    end
  end

  private

  def complete_params
    params.require(:user).permit(
      :email,
      :password,
      :password_confirmation,
      :name,
      professor_attributes: %i[id department],
      student_attributes: %i[id program start_year]
    )
  end

  def redirect_if_completed
    redirect_to root_path if current_user.first_login?
  end
end
