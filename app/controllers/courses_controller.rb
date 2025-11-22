class CoursesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_course, only: %i[home show edit update]

  # AQUI NAO TEM NADA FEITO AINDA !!
  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @course.update(course_params)
        format.html { redirect_to @course, notice: 'Course was successfully updated.', status: :see_other }
        format.json { render :show, status: :ok, location: @course }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @course.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @course = course.new
  end

  def create
    @course = current_user.build_course(course_params)
    if @course.save
      redirect_to root_path, notice: 'course created!'
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @course.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_course
    @course = course.find(params[:id])
  end

  def course_params
    params.require(:course).permit(:name, :course_id, :professor_id, :credits)
  end
end
