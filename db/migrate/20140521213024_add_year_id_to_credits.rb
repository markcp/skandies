class AddYearIdToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :year_id, :integer
  end
end
