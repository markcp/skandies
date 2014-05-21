class CreateScenes < ActiveRecord::Migration
  def change
    create_table :scenes do |t|
      t.string :title
      t.integer :movie_id

      t.timestamps
    end
  end
end
