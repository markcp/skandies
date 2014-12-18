class BallotsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user,   only: [:show, :edit, :update]

  def new
    @user = current_user
    @year = Year.current
    @ballot = @user.ballots.build(year: @year)
  end

  def create
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

    def correct_user
      @ballot = Ballot.find(params[:id])
      @user = @ballot.user
      redirect_to(root_url) unless current_user?(@user)
    end
end
