class AddProfileFieldsToBallots < ActiveRecord::Migration
  def change
    add_column :ballots, :nbr_ratings, :integer
    add_column :ballots, :average_rating, :decimal, precision: 3, scale: 2
    add_column :ballots, :four_ratings, :integer
    add_column :ballots, :three_pt_five_ratings, :integer
    add_column :ballots, :three_ratings, :integer
    add_column :ballots, :two_pt_five_ratings, :integer
    add_column :ballots, :two_ratings, :integer
    add_column :ballots, :one_pt_five_ratings, :integer
    add_column :ballots, :one_ratings, :integer
    add_column :ballots, :zero_ratings, :integer
    add_column :ballots, :selectivity_index, :integer
    add_index :ballots, [:year_id, :nbr_ratings]
  end
end
