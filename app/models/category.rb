class Category < ActiveRecord::Base
  has_many :votes
  has_many :category_vote_groups
  has_many :credits, foreign_key: 'results_category_id'

  validates :name, presence: true

  def self.ballot_display_order
    categories = []
    categories << Category.best_picture
    categories << Category.best_supporting_actor
    categories << Category.best_director
    categories << Category.best_supporting_actress
    categories << Category.best_actress
    categories << Category.best_screenplay
    categories << Category.best_actor
    categories << Category.best_scene
    categories
  end

  def display_name
    "Best " + name.titleize
  end

  def self.best_picture
    where( name: "picture").last
  end

  def self.best_director
    where(name: "director").last
  end

  def self.best_actress
    where(name: "actress").last
  end

  def self.best_actor
    where(name: "actor").last
  end

  def self.best_supporting_actress
    where(name: "supporting actress").last
  end

  def self.best_supporting_actor
    where(name: "supporting actor").last
  end

  def self.best_screenplay
    where(name: "screenplay").last
  end

  def self.best_scene
    where(name: "scene").last
  end

  def is_acting_category
    name == "actor" || name == "actress" || name == "supporting actor" || name == "supporting actress"
  end

  def complementary_category
    complementary_category = case name
      when "actress" then Category.where(name: "supporting actress").first
      when "supporting actress" then Category.where(name: "actress").first
      when "actor" then Category.where(name: "supporting actor").first
      when "supporting actor" then Category.where(name: "actor").first
      else nil
    end
  end

  def tiebreaker_category
    if name == "actress" || name == "actor"
      return self
    else
      return self.complementary_category
    end
  end

  def results_in_order(year)
    ballots = Ballot.where(year: year, complete: true).all
    votes_array = []
    ballots.each do |ballot|
      ballot.votes.where(category: self).each do |v|
        votes_array << v
      end
    end
    if self.is_acting_category || self.name == "scene"
      comp_votes_array = []
      ballots.each do |ballot|
        ballot.votes.where(category: self.complementary_category).each do |v|
          comp_votes_array << v
        end
      end
      votes_values_counted = []
      results_array = []
      votes_array.each do |v1|
        vote_hash = {}
        points = v1.points
        nbr_votes = 1
        votes_array.each do |v2|
          if v1 != v2 && v1.value == v2.value && v1.movie_id == v2.movie_id
            points = points + v2.points
            nbr_votes = nbr_votes + 1
            votes_array.delete(v2)
          end
        end
        comp_votes_array.each do |cv|
          if v1.value == cv.value && v1.movie_id == cv.movie_id
            puts "comp vote"
            points = points + cv.points
            nbr_votes = nbr_votes + 1
            comp_votes_array.delete(cv)
          end
        end
        vote_hash[:value] = v1.value
        vote_hash[:movie] = v1.movie.title
        vote_hash[:points] = points
        vote_hash[:nbr_votes] = nbr_votes
        results_array << vote_hash
      end
    else
      votes_values_counted = []
      results_array = []
      votes_array.each do |v1|
        vote_hash = {}
        points = v1.points
        nbr_votes = 1
        votes_array.each do |v2|
          if v1 != v2 && v1.movie_id == v2.movie_id
            points = points + v2.points
            nbr_votes = nbr_votes + 1
            votes_array.delete(v2)
          end
        end
        if self.name == "director"
          vote_hash[:value] = v1.movie.director_name
        elsif self.name == "screenplay"
          vote_hash[:value] = v1.movie.screenwriter_name
        else
          vote_hash[:value] = ''
        end
        vote_hash[:movie] = v1.movie.title
        vote_hash[:points] = points
        vote_hash[:nbr_votes] = nbr_votes
        results_array << vote_hash
      end
    end
    # results_array.sort! { |x,y| y["points"].to_i <=> x["points"].to_i }
    results_array.sort_by! { |x| [x[:points], x[:nbr_votes]] }.reverse!
    results_array
  end
end
