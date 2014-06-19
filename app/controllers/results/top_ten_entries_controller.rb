class Results::TopTenEntriesController < ApplicationController
  def index
    @year = Year.get_display_year(params[:year])
    @ballots = @year.ballots.by_user_name(@year)
  end
end
