class MoviesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:admin_edit]

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

  def admin_edit
    @year = active_voting_year
    @user = current_user
    @category = Category.find(params[:cat_id])
    @movies = Movie.voted_for(@year, @category)
  end

  def admin_update
    params['movie'].keys.each do |id|
      @movie = Movie.find(id.to_i)
      @movie.update_attributes(movie_params(id))
    end
    redirect_to admin_edit_movies_path(cat_id: params[:cat_id])
  end

  private
    def movie_params(id)
      params.require(:movie).fetch(id).permit(:screenwriter_display, :director_display)
    end

    def admin_user
      @user = current_user
      redirect_to(root_url) unless @user.admin
    end

end
