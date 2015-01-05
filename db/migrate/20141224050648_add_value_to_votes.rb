class AddValueToVotes < ActiveRecord::Migration
  def change
    add_column :votes, :value, :string
    add_index :votes, :value
  end
end
