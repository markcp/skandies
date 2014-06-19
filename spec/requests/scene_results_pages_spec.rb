require 'rails_helper'

describe "Scene results pages" do

  describe "Scene result" do
    let!(:movie) { create(:movie) }
    let!(:category) { create(:category, name: "scene") }
    let!(:scene) { create(:scene, title: "Foo", movie: movie) }
    let!(:u1) { create(:user, first_name: "Jim", last_name: "Jam") }
    let!(:u2) { create(:user, first_name: "James", last_name: "Smith") }
    let!(:b1) { create(:ballot, user: u1) }
    let!(:b2) { create(:ballot, user: u2) }
    let!(:v1) { create(:vote, category: category, credit: nil, scene: scene, ballot: b1, points: 30) }
    let!(:v2) { create(:vote, category: category, credit: nil, scene: scene, ballot: b2, points: 20) }

    before { visit results_scene_path(scene) }

    it "has scene votes" do
      expect(page).to have_content("Best Scene")
      expect(page).to have_content(movie.title)
      expect(page).to have_content(scene.title)
      expect(page).to have_content(u1.name)
      expect(page).to have_content(v1.points)
      expect(page).to have_content(u2.name)
      expect(page).to have_content(v2.points)
    end
  end

end
