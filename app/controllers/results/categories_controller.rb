class Results::CategoriesController < ApplicationController
  def show
    @year = Year.get_display_year(params[:year])
    @category = Category.find(params[:id])
    @categories = Category.all

    if @category.name == "director" || @category.name == "picture" || @category.name == "screenplay"
      @movies = Movie.results_list(@year, @category)
    elsif @category.name == "actress" || @category.name == "actor" || @category.name == "supporting actress" || @category.name == "supporting actor"
      @credits = Credit.results_list(@year, @category)
    elsif @category.name == "scene"
      @scenes = Scene.results_list(@year)
    end
  end

  def index
    @year = Year.get_display_year(params[:year])
    @categories = Category.all
  end

end
