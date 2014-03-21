class CreateTopTenEntries < ActiveRecord::Migration
  def change
    create_table :top_ten_entries do |t|
      t.integer :ballot_id
      t.string :value
      t.integer :rank

      t.timestamps
    end
    add_index :top_ten_entries, :ballot_id
  end
end
