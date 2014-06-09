require 'rails_helper'

describe Person do

  it "has a valid factory" do
    expect(build(:person)).to be_valid
  end

  it { should validate_presence_of :last_name }
  it { should ensure_inclusion_of(:gender).in_array(['M','F','O']) }
end
