require 'rails_helper'

describe TopTenEntry do

  it "has a valid factory" do
    expect(build(:top_ten_entry)).to be_valid
  end

  it { should validate_presence_of :ballot }
  it { should validate_presence_of :value }
  it { should ensure_inclusion_of(:rank).in_range(0..10) }

  describe "rank scope" do
    let!(:tte1) { create(:top_ten_entry, rank: 2) }
    let!(:tte2) { create(:top_ten_entry, rank: 1) }

    it "should return top ten entries in rank order" do
      expect(TopTenEntry.by_rank).to eq([tte2,tte1])
    end
  end
end
