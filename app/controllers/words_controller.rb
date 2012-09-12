class WordsController < ApplicationController
  # GET /words/1
  # GET /words/1.json
  def show
    @word = WordInfo.find_by_word(params[:word])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @word }
    end
  end
end
