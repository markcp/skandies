class AddResultsFieldsToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :points, :integer
    add_column :scenes, :nbr_votes, :integer
    add_index :scenes, [:year_id, :points, :nbr_votes]
  end
end
