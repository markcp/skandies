class CreateVotes < ActiveRecord::Migration
  def change
    create_table :votes do |t|
      t.integer :ballot_id
      t.integer :category_id
      t.integer :credit_id
      t.integer :movie_id
      t.integer :points

      t.timestamps
    end
    add_index :votes, [:ballot_id, :category_id]
    add_index :votes, :category_id
    add_index :votes, :credit_id
  end
end
