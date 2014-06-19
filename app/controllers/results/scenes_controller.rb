class Results::ScenesController < ApplicationController

  def show
    @scene = Scene.find(params[:id])
    category = Category.where(name: "scene").first
    @votes = @scene.votes.by_points_and_user_name(category)
  end
end
