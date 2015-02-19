class AddMorePrecisionToAverageRatingToMovies < ActiveRecord::Migration
  def change
    change_column :movies, :average_rating, :decimal, precision: 5, scale: 4
  end
end
