class ChangeAverageRatingDecimalPrecisionOnMovies < ActiveRecord::Migration
  def change
    change_column :movies, :average_rating, :decimal, precision: 4, scale: 3
  end
end
