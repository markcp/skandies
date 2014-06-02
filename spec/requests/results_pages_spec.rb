require 'spec_helper'

describe "Results pages" do

  describe "voting results page - best picture" do
    let!(:m1) { FactoryGirl.create(:movie, picture_points: 200, pitcure_votes: 30)}
    let!(:m2) { FactoryGirl.create(:movie, picture_points: 250, picture_votes: 35)}
    let!(:m3) { FactoryGirl.create(:movie, picture_points: 200, picture_votes: 29)}

    before { visit results_path }
  end
end
