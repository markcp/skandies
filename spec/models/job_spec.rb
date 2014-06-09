require 'rails_helper'

describe Job do

  it "has a valid factory" do
    expect(build(:job)).to be_valid
  end

  it { should validate_presence_of :name }
end
