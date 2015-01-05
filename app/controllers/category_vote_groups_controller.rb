class CategoryVoteGroupsController < ApplicationController
  before_action :get_user_and_year
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit]

  def show
    @category_vote_group = CategoryVoteGroup.find(params[:id])
  end

  def new
    @ballot = Ballot.where(user: @user, year: @year).first
    @category = Category.find(params[:cat_id])
    @category_vote_group = CategoryVoteGroup.new(category: @category, ballot: @ballot)
    10.times do
      @category_vote_group.votes.build(category: @category, ballot: @ballot)
    end
    @movies = Movie.where(year: @year).all.by_title
  end

  def create
    @category_vote_group = CategoryVoteGroup.new(category_vote_group_params)
    if @category_vote_group.save
      @ballot = @category_vote_group.ballot
      redirect_to @ballot
    else
      @ballot = Ballot.where(user: @user, year: @year).first
      @category = @category_vote_group.category
      @movies = Movie.where(year: @year).all.by_title
      if @category_vote_group.votes.length < 10
        (10 - @category_vote_group.votes.length).times do
          @category_vote_group.votes.build(category: @category, ballot: @category_vote_group.ballot)
        end
      end
      render 'new'
    end
  end

  def edit
    @category_vote_group = CategoryVoteGroup.find(params[:id])
    @category = @category_vote_group.category
    if @category_vote_group.votes.length < 10
      (10 - @category_vote_group.votes.length).times do
        @category_vote_group.votes.build(category: @category, ballot: @category_vote_group.ballot)
      end
    end
    @movies = Movie.where(year: @year).all.by_title
  end

  def update
    @category_vote_group = CategoryVoteGroup.find(params[:id])
    @category = @category_vote_group.category
    @movies = Movie.where(year: @year).all.by_title
    @ballot = @category_vote_group.ballot
    if @category_vote_group.update(category_vote_group_params)
      redirect_to @ballot
    else
      if @category_vote_group.votes.length < 10
        (10 - @category_vote_group.votes.length).times do
          @category_vote_group.votes.build(category: @category, ballot: @category_vote_group.ballot)
        end
      end
      @movies = Movie.where(year: @year).all.by_title
      render 'edit'
    end
  end

  private
    def category_vote_group_params
      params.require(:category_vote_group).permit(:ballot_id, :category_id, votes_attributes: [:movie_id, :points, :ballot_id, :category_id, :id, :scene_id, :value])
    end

    def get_user_and_year
      @user = current_user
      @year = active_voting_year
    end

    def correct_user
      @category_vote_group = CategoryVoteGroup.find(params[:id])
      @ballot = @category_vote_group.ballot
      @user = @ballot.user
      redirect_to(root_url) unless current_user?(@user)
    end
end
