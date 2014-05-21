class CreateRatings < ActiveRecord::Migration
  def change
    create_table :ratings do |t|
      t.integer :ballot_id
      t.integer :movie_id
      t.decimal :value, precision: 2, scale: 1

      t.timestamps
    end
    add_index :ratings, :ballot_id
    add_index :ratings, :movie_id
  end
end
