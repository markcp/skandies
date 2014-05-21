class RemoveValueFromVotes < ActiveRecord::Migration
  def change
    remove_column :votes, :value, :string
  end
end
