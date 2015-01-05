class CreateCategoryVoteGroups < ActiveRecord::Migration
  def change
    create_table :category_vote_groups do |t|
      t.integer :ballot_id
      t.integer :category_id

      t.timestamps null: false
    end
  end
end
