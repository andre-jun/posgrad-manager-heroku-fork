class PublicationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_publication, only: %i[show edit update]

  def index
    @publications = Publication.all.order(publication_date: :desc)
  end

  def show
  end

  def edit
  end

  def update
    respond_to do |format|
      if @publication.update(publication_params)
        format.html { redirect_to @publication, notice: 'Publicação foi corretamente atualizada!.', status: :see_other }
        format.json { render :show, status: :ok, location: @publication }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @publication.errors, status: :unprocessable_entity }
      end
    end
  end

  def new
    @publication = Publication.new
  end

  def create
    @publication = Publication.build(publication_params)
    if @publication.save
      redirect_to @publication, notice: 'Publicação criada!'
    else
      format.html { render :new, status: :unprocessable_entity }
      format.json { render json: @publication.errors, status: :unprocessable_entity }
    end
  end

  private

  def set_publication
    @publication = Publication.find(params[:id])
  end

  def publication_params
    params.require(:publication).permit(:publication_id, :professor_id, :student_id, :name, :abstract, :link,
                                        :publication_date)
  end
end
