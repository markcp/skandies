class CreateYears < ActiveRecord::Migration
  def change
    create_table :years do |t|
      t.string :name
      t.datetime :open_voting, default: "2001-01-01 00:00:00"
      t.datetime :close_voting, default: "2001-01-01 00:00:00"
      t.datetime :display_results, default: "2001-01-01 00:00:00"

      t.timestamps
    end
  end
end
