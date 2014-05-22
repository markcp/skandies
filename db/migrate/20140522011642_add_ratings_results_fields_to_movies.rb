class AddRatingsResultsFieldsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :nbr_ratings, :integer
    add_column :movies, :average_rating, :decimal, precision: 3, scale: 2
    add_column :movies, :four_ratings, :integer
    add_column :movies, :three_pt_five_ratings, :integer
    add_column :movies, :three_ratings, :integer
    add_column :movies, :two_pt_five_ratings, :integer
    add_column :movies, :two_ratings, :integer
    add_column :movies, :one_pt_five_ratings, :integer
    add_column :movies, :one_ratings, :integer
    add_column :movies, :zero_ratings, :integer
    add_column :movies, :standard_dev, :decimal, precision: 3, scale: 2
    add_index :movies, [:year_id, :average_rating]
  end
end
