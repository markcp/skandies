class AddResultsFieldsToMovies < ActiveRecord::Migration
  def change
    add_column :movies, :picture_points, :integer
    add_column :movies, :picture_votes, :integer
    add_column :movies, :director_points, :integer
    add_column :movies, :director_votes, :integer
    add_column :movies, :screenplay_points, :integer
    add_column :movies, :screenplay_votes, :integer
    add_index :movies, [:year_id, :picture_points, :picture_votes], name: 'index_movies_on_picture_results_fields'
    add_index :movies, [:year_id, :director_points, :director_votes], name: 'index_movies_on_director_results_fields'
    add_index :movies, [:year_id, :screenplay_points, :screenplay_votes], name: 'index_movies_on_screenplay_results_fields'
  end
end
