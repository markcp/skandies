require 'rails_helper'

describe TopTenEntry do

  it "has a valid factory" do
    expect(build(:top_ten_entry)).to be_valid
  end

  it { should validate_presence_of :ballot }
  it { should validate_presence_of :value }
  it { should ensure_inclusion_of(:rank).in_range(0..10) }
end
