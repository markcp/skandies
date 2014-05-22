class AddYearIdToScenes < ActiveRecord::Migration
  def change
    add_column :scenes, :year_id, :integer
  end
end
