class AddResultsFieldsToCredits < ActiveRecord::Migration
  def change
    add_column :credits, :results_category_id, :integer
    add_column :credits, :points, :integer
    add_column :credits, :nbr_votes, :integer
    add_index :credits, [:year_id, :results_category_id, :points, :nbr_votes], name: 'index_credits_on_results_fields'
  end
end
