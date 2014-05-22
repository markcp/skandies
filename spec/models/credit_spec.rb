require 'spec_helper'

describe Credit do

  let(:movie) { FactoryGirl.create(:movie) }
  let(:person) { FactoryGirl.create(:person) }
  let(:job) { FactoryGirl.create(:job) }
  let(:year) { FactoryGirl.create(:year) }
  let(:category) { FactoryGirl.create(:category) }
  before { @credit = movie.credits.build( person: person, job: job, year: year,
                                          category: category) }

  subject { @credit }

  it { should respond_to(:person_id) }
  it { should respond_to(:person) }
  it { should respond_to(:movie_id) }
  it { should respond_to(:movie) }
  it { should respond_to(:job_id) }
  it { should respond_to(:job) }
  it { should respond_to(:year_id) }
  it { should respond_to(:year) }
  it { should respond_to(:votes) }
  it { should respond_to(:results_category_id) }
  it { should respond_to(:category) }
  it { should respond_to(:points) }
  it { should respond_to(:votes) }

  its(:person) { should eq person }
  its(:movie) { should eq movie }
  its(:job) { should eq job }
  its(:year) { should eq year }
  its(:results_category_id) { should eq category.id }

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

  describe "when year_id is not present" do
    before { @credit.year_id = nil }
    it { should_not be_valid }
  end
end
