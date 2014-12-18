class UsersController < ApplicationController

  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user,   only: [:show, :edit, :update]

  def show
    @year = voting_display_year
    @active_voting_year = active_voting_year
    @user = User.find(params[:id])
    @active_year_ballot = Ballot.where(user: @user, year: @active_voting_year).last
    @past_ballots = Ballot.past_ballots_by_user(@user, @active_voting_year)
  end

  def edit
    @year = voting_display_year
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    if @user.update_attributes(user_params)
      flash[:notice] = "Profile updated"
      redirect_to @user
    else
      @year = voting_display_year
      render 'edit'
    end
  end

  private

    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end

    # Confirms the correct user.
    def correct_user
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end
end
