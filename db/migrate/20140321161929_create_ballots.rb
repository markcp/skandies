class CreateBallots < ActiveRecord::Migration
  def change
    create_table :ballots do |t|
      t.integer :user_id
      t.integer :year_id
      t.boolean :complete, default: false

      t.timestamps
    end
    add_index :ballots, [ :year_id, :complete ]
    add_index :ballots, [ :user_id, :complete ]
  end
end
