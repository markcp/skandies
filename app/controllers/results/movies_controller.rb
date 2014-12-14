class Results::MoviesController < ApplicationController
  def index
    @year = Year.get_display_year(params[:year])
    @movies = Movie.ratings_results_list(@year)
  end

  def show
    @year = Year.get_display_year(params[:year])
    @category = Category.find(params[:category])
    @movie = Movie.find(params[:id])
    @votes = @movie.votes.by_category_and_points_and_user_name(@category)
  end

  def supplementary_ratings
    @year = Year.get_display_year(params[:year])
    @movies = Movie.less_than_five_ratings(@year)
    @shunned_movies = Movie.zero_ratings(@year)
  end
end
