class AddRatingsGroupIdToRatings < ActiveRecord::Migration
  def change
    add_column :ratings, :ratings_group_id, :integer
  end
end
