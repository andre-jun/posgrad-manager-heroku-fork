class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_user, only: %i[ edit update show ]

  def show
  end

  def contact_info
    @user = User.find_by(params[:user_id])
  end

  def create
    @user = User.create(user_params)
    if @user.save
      redirect_to "/", notice: "User created!"
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @user.errors, status: :unprocessable_entity }
    end
  end

  def edit
    return unless !@user.id == current_user.id

    redirect_to root_path, notice: "You're not the correct user to edit this."
  end

  def update
    if @user.update(user_params)
      redirect_to root_path, notice: 'User was successfully updated!'
    else
      render :edit
    end
  end

  private

  def set_user
    @user = User.find_by(params[:id])
  end

  def user_params
    params.require(:user).permit(:user_id, :name, :surname, :email, :login_id, :user_id, :nusp, :pronouns, 
                                  :status, :password, :password_confirmation, :pronoun, :status,
                                  student_attributes: [ :id, :role, :lattes_link, 
                                  :lattes_last_update, :pretended_career, :join_date],
                                  professor_attributes: [ :id, :research_area, :department],
                                  professor_attributes: [ :id, :role],
                                  contact_info_attributes: [ :phone_number, :room_number, :id ])
    
    # aqui eu quero que o password default seja o nusp
    # # params[:user][:login_id] = params[:nusp]
    # # params[:user][:password] = params[:nusp]
    # # params[:user][:password_confirmation] = params[:nusp]
    # params.merge!(:password, params[:nusp])
    # params.merge!(:password_confirmation, params[:nusp])
    # params[:password] = "14656895"
    # params[:password_confirmation] = "14656895"
    # params[:user][:password] = params.nusp
    #params[:user][:password_confirmation] = params.nusp



    # password_params = ActionController::Parameters.new(password: params[:nusp], password_confirmation: params[:nusp])
    # permitted = password_params.permit(:password, :password_confirmation)
    # # params[:user][:password_confirmation] = params[:user][:nusp]
    # params.merge!(permitted)
  end
end
