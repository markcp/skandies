require 'spec_helper'

describe Year do

  before{ @year = Year.new(name: "2013") }
  subject { @year }

  it { should respond_to(:name) }
  it { should respond_to(:open_voting) }
  it { should respond_to(:close_voting) }
  it { should respond_to(:display_results) }

  it { should be_valid }

  describe "when name is not present" do
    before { @year.name = " " }
    it { should_not be_valid }
  end

  describe "when open_voting is not present" do
    before { @year.open_voting = " " }
    it { should_not be_valid }
  end

  describe "when close_voting is not present" do
    before { @year.close_voting = " " }
    it { should_not be_valid }
  end

  describe "when display_results is not present" do
    before { @year.display_results = " " }
    it { should_not be_valid }
  end

  it "should contain a default value in open_voting" do
    @year.save
    expect(@year.open_voting).to eq("2001-01-01 00:00:00")
  end

  it "should contain a default value in close_voting" do
    @year.save
    expect(@year.close_voting).to eq("2001-01-01 00:00:00")
  end

  it "should contain a default value in display_results" do
    @year.save
    expect(@year.display_results).to eq("2001-01-01 00:00:00")
  end
end
