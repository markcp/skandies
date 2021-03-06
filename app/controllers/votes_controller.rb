class VotesController < ApplicationController
  before_action :logged_in_user
  before_action :admin_user, only: [:admin_edit, :admin_index, :admin_view_leaders]

  def admin_index
    @year = active_voting_year
    @user = current_user
    @categories = Category.all
  end

  def admin_edit
    @year = active_voting_year
    @user = current_user
    @category = Category.find(params[:cat_id])
    @votes = Vote.by_year_category_movie(@year, @category)
  end

  def admin_update
    params['vote'].keys.each do |id|
      @vote = Vote.find(id.to_i)
      @vote.update_attributes(vote_params(id))
    end
    redirect_to admin_edit_votes_path(cat_id: @vote.category_id)
  end

  def admin_view_leaders
    @year = active_voting_year
    @user = current_user
    @category = Category.find(params[:cat_id])
    puts @category.name
    @results_array = @category.results_in_order(@year)
    puts "results_array" + @results_array.to_s
  end

  # def new
  #   @year = active_voting_year
  #   @user = current_user
  #   @ballot = Ballot.where(user: @user, year: @year).last
  #   @category = Category.find(params[:cat_id])
  #   @movies = Movie.where(year: @year).all
  #   @votes = []
  #   2.times do
  #     @votes << @ballot.votes.build(category: @category)
  #   end
  # end

  # def create
  #   @year = active_voting_year
  #   @user = current_user
  #   @ballot = Ballot.where(user: @user, year: @year).last
  #   params[:votes].each do
  #     @vote = Vote.new(vote_params)
  #     if !@vote.save
  #       render 'new'
  #     end
  #   end
  #   redirect_to @ballot
  # end

  private
    def vote_params
      params.require(:votes).each do |p|
        p.permit(:movie_id, :category_id, :points, :ballot_id, :credit_id, :scene_id)
      end
    end

    def vote_params(id)
      params.require(:vote).fetch(id).permit( :value )
    end

    def admin_user
      @user = current_user
      redirect_to(root_url) unless @user.admin
    end
end
