class BallotsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user,   only: [:show, :edit, :update]

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
    @categories = Category.all
  end

  def edit
  end

  def update
  end


  private

    def ballot_params
      params.require(:ballot).permit(:user_id, :year_id)
    end

    def correct_user
      @ballot = Ballot.find(params[:id])
      @user = @ballot.user
      redirect_to(root_url) unless current_user?(@user)
    end
end
