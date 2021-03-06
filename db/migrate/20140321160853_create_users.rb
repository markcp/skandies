class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :first_name
      t.string :last_name
      t.string :email
      t.boolean :admin, default: false

      t.timestamps
    end
    add_index :users, :last_name
    add_index :users, :email, unique: true
  end
end
