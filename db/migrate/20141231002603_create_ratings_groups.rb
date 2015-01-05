class CreateRatingsGroups < ActiveRecord::Migration
  def change
    create_table :ratings_groups do |t|
      t.integer :ballot_id

      t.timestamps null: false
    end
  end
end
