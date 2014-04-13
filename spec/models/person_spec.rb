require 'spec_helper'

describe Person do
  before { @person = Person.new(first_name: "Buster", last_name: "Keaton", gender: "M") }

  subject { @person }

  it { should respond_to(:first_name) }
  it { should respond_to(:last_name) }
  it { should respond_to(:gender) }
  it { should respond_to(:last_name_first) }
  it { should respond_to(:credits) }

  it { should be_valid }

  describe "when last_name is not present" do
    before { @person.last_name = " " }
    it { should_not be_valid }
  end

  describe "when gender is not present" do
    before { @person.last_name = " " }
    it { should_not be_valid }
  end

  describe "when gender is not 'M', 'F', or 'O'" do
    before { @person.gender = "Q" }
    it { should_not be_valid }
  end
end
