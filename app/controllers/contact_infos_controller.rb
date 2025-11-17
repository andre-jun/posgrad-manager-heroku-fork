class ContactInfosController < ApplicationController
  before_action :authenticate_user!
  before_action :set_contact_info, only: %i[show edit update]

  def show
  end

  def edit
    return unless !@contact_info.user.id == current_user.id

    redirect_to root_path, notice: "You're not the correct user to edit this."
  end

  def update
    if @contact_info.update(contact_info_params)
      redirect_to root_path, notice: 'Contact info was successfully updated!'
    else
      render :edit
    end
  end

  def new
    @contact_info = ContactInfo.new
  end

  def create
    @contact_info = current_user.build_contact_info(contact_info_params)
    if @contact_info.save
      redirect_to root_path, notice: 'Contact info created!'
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @contact_info.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_contact_info
    @contact_info = ContactInfo.find_by(params[:id])
  end

  def contact_info_params
    params.require(:contact_info).permit(:contact_info_id, :user_id, :phone_number, :room_number)
  end
end
