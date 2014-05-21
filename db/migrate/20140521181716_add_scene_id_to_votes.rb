class AddSceneIdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :scene_id, :integer
  end
end
