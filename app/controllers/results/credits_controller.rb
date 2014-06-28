class Results::CreditsController < ApplicationController

  def show
    @credit = Credit.find(params[:id])
    @category = @credit.category
    @votes = @credit.votes.by_points_and_user_name
  end
end
