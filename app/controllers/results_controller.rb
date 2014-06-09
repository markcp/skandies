class ResultsController < ApplicationController
  def index
    if params[:year_name]
      @year = Year.where("name = ? and display_results < ?", params[:year_name], Time.zone.now ).first
    else
      @year = Year.where(display_results: true).last
    end

    if params[:category_name]
      if params[:category_name] == "director"
        @category = Category.where(name: "Director").first
        @results_items = Movie.where("year_id = ? and director_points > ?", @year.id, 0).order(director_points: :desc, director_votes: :desc, title_index: :asc)
      elsif params[:category_name] == "actress"
        @category = Category.where(name: "Actress").first
        @results_items = Credit.where("year_id = ? and results_category_id = ? and points > ?", @year.id, @category.id, 0).order(points: :desc, nbr_votes: :desc).all
      elsif params[:category_name] == "actor"
        @category = Category.where(name: "Actor").first
        @results_items = Credit.where("year_id = ? and results_category_id = ? and points > ?", @year.id, @category.id, 0).order(points: :desc, nbr_votes: :desc)
      elsif params[:category_name] == "supporting_actor"
        @category = Category.where(name: "Supporting Actor").first
        @results_items = Credit.where("year_id = ? and results_category_id = ? and points > ?", @year.id, @category.id, 0).order(points: :desc, nbr_votes: :desc)
      elsif params[:category_name] == "supporting_actress"
        @category = Category.where(name: "Supporting Actress").first
        @results_items = Credit.where("year_id = ? and results_category_id = ? and points > ?", @year.id, @category.id, 0).order(points: :desc, nbr_votes: :desc)
      elsif params[:category_name] == "screenplay"
        @category = Category.where(name: "Screenplay").first
        @results_items = Movie.where("year_id = ? and screenplay_points > ?", @year.id, 0).order(screenplay_points: :desc, screenplay_votes: :desc, title_index: :asc)
      elsif params[:category_name] == "scene"
        @category = Category.where(name: "Scene").first
        @results_items = Scene.where("year_id = ? and points > ?", @year.id, 0).order(points: :desc, nbr_votes: :desc)
      else
        @category = Category.where(name: "Picture").first
        @results_items = Movie.where("year_id = ? and picture_points > ?", @year.id, 0).order(picture_points: :desc, picture_votes: :desc, title_index: :asc).all
      end
    else
      @category = Category.where(name: "Picture").first
      @results_items = Movie.where("year_id = ? and picture_points > ?", @year.id, 0).order(picture_points: :desc, picture_votes: :desc, title_index: :asc).all
    end
    puts @results_items.length
  end
end
