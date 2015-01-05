class VotesController < ApplicationController

  def new
    @year = active_voting_year
    @user = current_user
    @ballot = Ballot.where(user: @user, year: @year).last
    @category = Category.find(params[:cat_id])
    @movies = Movie.where(year: @year).all
    @votes = []
    2.times do
      @votes << @ballot.votes.build(category: @category)
    end
  end

  def create
    @year = active_voting_year
    @user = current_user
    @ballot = Ballot.where(user: @user, year: @year).last
    params[:votes].each do
      @vote = Vote.new(vote_params)
      if !@vote.save
        render 'new'
      end
    end
    redirect_to @ballot
  end

  private
    def vote_params
      params.require(:votes).each do |p|
        p.permit(:movie_id, :category_id, :points, :ballot_id, :credit_id, :scene_id)
      end
    end
end
