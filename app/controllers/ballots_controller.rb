class BallotsController < ApplicationController
  before_action :logged_in_user, only: [:show, :edit, :update]
  before_action :correct_user,   only: [:show, :edit, :update]

  def new
  end

  def show
    @ballot = Ballot.find(params[:id])
  end
end
