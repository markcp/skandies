class MoviesController < ApplicationController

  def index
    if params[:term]
      @movies = Movie.where('given_name LIKE ?', "#{params[:term]}%").all
    else
      @movies = Movie.all
    end

    respond_to do |format|
      format.json { render json: @movies.to_json }
    end
  end

end
