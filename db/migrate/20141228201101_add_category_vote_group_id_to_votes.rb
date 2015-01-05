class AddCategoryVoteGroupIdToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :category_vote_group_id, :integer
  end
end
