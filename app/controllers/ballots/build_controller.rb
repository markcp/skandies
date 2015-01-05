class Ballots::BuildController < ApplicationController
  include Wicked::Wizard

  steps :vote_in_category

  def show
    @year = active_voting_year
    @user = current_user
    @ballot = Ballot.find(params[:ballot_id])
    @category = Category.find(params[:cat_id])
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
    render_wizard
  end

  def update
    @ballot = Ballot.find(params[:ballot_id])
    @ballot.update(build_params)
    render_wizard @ballot
  end

  private
    def build_params
      params.require(:ballot).permit(votes_attributes: [:id, :movie_id, :credit_id, :scene_id, :ballot_id,
                                    :category_id, :value])
    end
end



