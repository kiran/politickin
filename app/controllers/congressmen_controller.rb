class CongressmenController < ApplicationController
  # GET /congressmen
  # GET /congressmen.json
  # def index
  #   @congressmen = Congressman.all

  #   respond_to do |format|
  #     format.html # index.html.erb
  #     format.json { render json: @congressmen }
  #   end
  # end

  # GET /congressmen/1
  # GET /congressmen/1.json

  helper_method :sort_column, :sort_direction

  def show
    @congressman = Congressman.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @congressman }
    end
  end

  def index
    @congressmen = Congressman.order(sort_column + ' ' + sort_direction)
  end

  private
  def sort_column
    Congressman.column_names.include?(params[:sort]) ? params[:sort] : "first_name"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ?  params[:direction] : "asc"
  end
end
