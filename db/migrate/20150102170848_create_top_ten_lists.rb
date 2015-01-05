class CreateTopTenLists < ActiveRecord::Migration
  def change
    create_table :top_ten_lists do |t|
      t.integer :ballot_id
      t.boolean :ranked

      t.timestamps null: false
    end
  end
end
