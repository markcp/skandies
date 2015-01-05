class AddTopTenListIdToTopTenListEntries < ActiveRecord::Migration
  def change
    add_column :top_ten_entries, :top_ten_list_id, :integer
  end
end
