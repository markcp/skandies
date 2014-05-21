class CreateMovies < ActiveRecord::Migration
  def change
    create_table :movies do |t|
      t.string :title
      t.string :title_index
      t.integer :year_id
      t.string :director_display
      t.string :screenwriter_display

      t.timestamps
    end
    add_index :movies, [:year_id, :title_index]
  end
end
