class BallotsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update, :submit_ballot]
  before_action :correct_user,   only: [:show, :edit, :update, :submit_ballot]

  autocomplete :movie, :title

  def new
    @user = current_user
    @year = voting_display_year
    @voting_year = active_voting_year
    @ballot = @user.ballots.build(year: @year)
  end

  def create
    @ballot = Ballot.new(ballot_params)

    if @ballot.save
      redirect_to @ballot
    else
      @user = current_user
      @year = voting_display_year
      @voting_year = active_voting_year
      render 'new'
    end
  end

  def show
    @ballot = Ballot.find(params[:id])
    @year = @ballot.year
    @categories = Category.ballot_display_order
  end

  def new_category_vote
    @user = current_user
    @year = active_voting_year
    @ballot = Ballot.where(user: @user, year: @year).last
    @category = Category.find(params[:cat_id])
    3.times do
      @ballot.votes.build(category: @category)
    end
    @movies = Movie.where(year: @year).all
  end

  def create_category_vote

  end

  def edit_category_vote
    @user = current_user
    @year = active_voting_year
    @ballot = Ballot.where(user: @user, year: @year).last
    @category = Category.find(params[:cat_id])
    @movies = Movie.where(year: @year).all
  end

  def update
    @ballot = Ballot.find(params[:id])
    if @ballot.update(ballot_params)
      redirect_to @ballot
    else
      @year = active_voting_year
      @user = current_user
      @ballot = Ballot.where(user: @user, year: @year).last
      @category = Category.find(session[:cat_id])
      if @ballot.votes.where(category: @category).all.length == 0
        @category_votes = []
        2.times do
          @category_votes << @ballot.votes.build(category: @category)
        end
      end
      if !@category_votes
        @category_votes = @ballot.votes.where(category: @category).all
      end
      @movies = Movie.where(year: @year).all
      render 'edit_category_vote', cat_id: @category.id
    end
  end

  def submit_ballot
    @ballot = Ballot.find(params[:id])
    if @ballot.valid_for_submission?
      @ballot.complete = true
      @ballot.save
    end
    flash[:notice] = "Ballot successfully submitted."
    redirect_to @ballot
  end

  private

    def ballot_params
      params.require(:ballot).permit(:user_id, :year_id, votes_attributes: [:movie_id, :points, :ballot_id, :category_id, :id, :scene_id, :value])
    end

    def correct_user
      @ballot = Ballot.find(params[:id])
      @user = @ballot.user
      redirect_to(root_url) unless current_user?(@user) || current_user.admin
    end

    def admin_user

    end
end
