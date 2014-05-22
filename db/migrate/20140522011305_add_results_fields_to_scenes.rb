class AddResultsFieldsToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :points, :integer
    add_column :scenes, :votes, :integer
    add_index :scenes, [:year_id, :points, :votes]
  end
end
