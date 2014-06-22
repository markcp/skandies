class Results::BallotsController < ApplicationController
  def index
    @year = Year.get_display_year(params[:year])
    @ballots = Ballot.by_nbr_ratings(@year)
  end

  def show
    @ballot = Ballot.find(params[:id])
  end
end
