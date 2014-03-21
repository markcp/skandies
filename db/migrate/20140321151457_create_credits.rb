class CreateCredits < ActiveRecord::Migration
  def change
    create_table :credits do |t|
      t.integer :person_id
      t.integer :movie_id
      t.integer :job_id

      t.timestamps
    end
    add_index :credits, :person_id
    add_index :credits, :movie_id
    add_index :credits, :job_id
  end
end
