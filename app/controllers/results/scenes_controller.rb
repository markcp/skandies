class Results::ScenesController < ApplicationController

  def show
    @year = Year.get_display_year(params[:year])
    @scene = Scene.find(params[:id])
    category = Category.where(name: "scene").first
    @votes = @scene.votes.by_category_and_points_and_user_name(category)
  end
end
