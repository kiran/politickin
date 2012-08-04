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
  def show
    @congressman = Congressman.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @congressman }
    end
  end

  def index
    @congressmen = Congressman.search(params[:search])
  end
end
