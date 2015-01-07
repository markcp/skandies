class RatingsGroupsController < ApplicationController
  before_action :get_user_and_year
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit]

  def new
    @ballot = Ballot.where(user: @user, year: @year).first
    @ratings_group = @ballot.build_ratings_group
    @movies = Movie.by_title.where(year: @year).all
    @movies.each do |movie|
      @ratings_group.ratings.build(movie: movie, ballot: @ballot)
    end
  end

  def create
    @ratings_group = RatingsGroup.new(ratings_group_params)
    if @ratings_group.save
      @ballot = @ratings_group.ballot
      redirect_to @ballot
    else
      render 'new'
    end
  end

  def edit
    @ratings_group = RatingsGroup.find(params[:id])
    @ballot = @ratings_group.ballot
    @movies = Movie.by_title.where(year: @year).all
    @rated_movie_ids = []
    @ratings_group.ratings.each do |rating|
      @rated_movie_ids << rating.movie.id
    end
    @movies.each do |movie|
      rating_present = false
      if !@rated_movie_ids.include?(movie.id)
        @ratings_group.ratings.build(movie: movie, ballot: @ballot)
      end
    end
  end

  def update
    @ratings_group = RatingsGroup.find(params[:id])
    @ballot = @ratings_group.ballot
    if @ratings_group.update(ratings_group_params)
      redirect_to @ballot
    else
      @movies = Movie.where(year: @year).all
      @movies.each do |movie|
        rating = @ratings_group.ratings.where(movie: movie).first
        if !rating
          @ratings_group.ratings.build(movie: movie, ballot: @ballot)
        end
      end
      render 'edit'
    end
  end

  private
    def ratings_group_params
      params.require(:ratings_group).permit(:ballot_id, ratings_attributes: [:movie_id, :ballot_id, :value, :id])
    end

    def get_user_and_year
      @user = current_user
      @year = active_voting_year
    end

    def correct_user
      @ratings_group = RatingsGroup.find(params[:id])
      @ballot = @ratings_group.ballot
      @user = @ballot.user
      redirect_to(root_url) unless current_user?(@user)
    end
end
