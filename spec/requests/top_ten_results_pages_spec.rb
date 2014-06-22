require 'rails_helper'

describe "Top ten results pages" do

  describe "top ten results" do
    let!(:year) { create(:year) }
    let!(:u1) { create(:user, first_name: "Foo", last_name: "Bar") }
    let!(:b1) { create(:ballot, user: u1, year: year) }
    let!(:tte1) { create(:top_ten_entry, ballot: b1) }
    let!(:u2) { create(:user, first_name: "Bar", last_name: "Bat") }
    let!(:b2) { create(:ballot, user: u2, year: year) }
    let!(:tte2) { create(:top_ten_entry, ballot: b2) }

    before { visit results_top_ten_entries_path(year: year.name) }

    it "has top ten results" do
      puts page.body
      expect(page).to have_content("Top Ten Lists")
      expect(page).to have_content(u1.name)
      expect(page).to have_content(tte1.value)
      expect(page).to have_content(u2.name)
      expect(page).to have_content(tte2.value)
    end
  end
end
