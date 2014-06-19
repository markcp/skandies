require 'rails_helper'

describe Person do

  it "has a valid factory" do
    expect(build(:person)).to be_valid
  end

  it { should validate_presence_of :last_name }
  it { should ensure_inclusion_of(:gender).in_array(['M','F','O']) }

  describe "full name" do
    let!(:person) { create(:person, first_name: "Foo", last_name: "Bar") }
    let!(:person_with_l_n_f) { create(:person, last_name_first: true, first_name: "Fi", last_name: "Far") }

    it "should return full name" do
      expect(person.name).to eq("Foo Bar")
    end

    context "person's name should be displayed last name first" do
      it "should return full name last-name-first" do
        expect(person_with_l_n_f.name).to eq("Far Fi")
      end
    end
  end
end
