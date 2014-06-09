require 'rails_helper'

describe Rating do

  it "has a valid factory" do
    expect(build(:rating)).to be_valid
  end

  it { should validate_presence_of :movie }
  it { should validate_presence_of :ballot }
  it { should validate_presence_of :value }
end
