class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user

  def show
  end

  def contact_info
    @user = current_user
  end

  def edit
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user), notice: 'Usuário corretamente atualizado!'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def set_user
    @user = current_user
  end

  def user_params
    params.require(:user).permit(
      :name, :surname, :email, :login_id, :nusp, :pronouns, :status,
      student_attributes: %i[id role lattes_link lattes_last_update pretended_career join_date],
      professor_attributes: %i[id research_area department role],
      contact_info_attributes: %i[id phone_number room_number]
    )
  end
end
