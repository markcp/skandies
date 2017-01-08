class TopTenListsController < ApplicationController
  before_action :get_user_and_year
  before_action :logged_in_user
  before_action :correct_user, only: [:show, :edit]

  def new
    @ballot = Ballot.where(user: @user, year: @year).first
    top_ten_list = @ballot.top_ten_list
    if top_ten_list
      redirect_to edit_top_ten_list_path(top_ten_list)
    else
      @top_ten_list = @ballot.build_top_ten_list(ranked: true)
      10.times do |i|
        @top_ten_list.top_ten_entries.build(ballot: @ballot, rank: i+1)
      end
    end
  end

  def create
    @top_ten_list = TopTenList.new(top_ten_list_params)
    if @top_ten_list.save
      redirect_to @top_ten_list.ballot
    else
      @ballot = @top_ten_list.ballot
      render 'new'
    end
  end

  def edit
    @top_ten_list = TopTenList.find(params[:id])
    @ballot = @top_ten_list.ballot
  end

  def update
    @top_ten_list = TopTenList.find(params[:id])
    if @top_ten_list.update(top_ten_list_params)
      redirect_to @top_ten_list.ballot
    else
      @ballot = @top_ten_list.ballot
      render 'edit'
    end
  end

  private
    def top_ten_list_params
      params.require(:top_ten_list).permit(:ballot_id, :ranked, top_ten_entries_attributes: [:ballot_id, :value, :rank, :id])
    end

    def get_user_and_year
      @user = current_user
      @year = active_voting_year
    end

    def correct_user
      @top_ten_list = TopTenList.find(params[:id])
      @user = @top_ten_list.ballot.user
      redirect_to(root_url) unless current_user?(@user)
    end
end
