require 'spec_helper'

describe Rating do
  let(:movie) { FactoryGirl.create(:movie) }
  let(:ballot) { FactoryGirl.create(:ballot) }
  before { @rating = ballot.ratings.build(movie: movie, value: "2.5") }

  subject { @rating }

  it { should respond_to(:movie_id) }
  it { should respond_to(:movie) }
  it { should respond_to(:ballot_id) }
  it { should respond_to(:ballot) }
  it { should respond_to(:value) }

  its(:movie) { should eq movie }
  its(:ballot) { should eq ballot }

  it { should be_valid }

  describe "when movie_id is not present" do
    before { @rating.movie_id = nil }
    it { should_not be_valid }
  end

  describe "when ballot_id is not present" do
    before { @rating.ballot_id = nil }
    it { should_not be_valid }
  end

  describe "when value is not present" do
    before { @rating.value = " " }
    it { should_not be_valid }
  end
end
