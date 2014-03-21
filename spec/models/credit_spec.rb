require 'spec_helper'

describe Credit do

  let(:movie) { FactoryGirl.create(:movie) }
  let(:person) { FactoryGirl.create(:person) }
  let(:job) { FactoryGirl.create(:job) }
  before { @credit = movie.credits.build( person: person, job: job) }

  subject { @credit }

  it { should respond_to(:person_id) }
  it { should respond_to(:person) }
  it { should respond_to(:movie_id) }
  it { should respond_to(:movie) }
  it { should respond_to(:job_id) }
  it { should respond_to(:job) }

  its(:person) { should eq person }
  its(:movie) { should eq movie }
  its(:job) { should eq job }

  it { should be_valid }

  describe "when person_id is not present" do
    before { @credit.person_id = nil }
    it { should_not be_valid }
  end

  describe "when movie_id is not present" do
    before { @credit.movie_id = nil }
    it { should_not be_valid }
  end

  describe "when job_id is not present" do
    before { @credit.job_id = nil }
    it { should_not be_valid }
  end
end
