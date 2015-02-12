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
    has_votes_array = []
    votes_array = []
    hold_array = []
    ballots.each do |ballot|
      ballot.votes.where(category: self).each do |v|
        votes_array << v
        already_in_array = false
        hold_array.each do |hv|
          if self.id == 1 || self.id == 2 || self.id == 7
            if v.movie_id == hv.movie_id
              already_in_array = true
            end
          else
            if v.movie_id == hv.movie_id && v.value == hv.value
              already_in_array = true
            end
          end
        end
        if !already_in_array
          has_votes_array << v
          hold_array << v
        end
      end
    end
    if self.is_acting_category || self.name == "scene"
      comp_votes_array = []
      ballots.each do |ballot|
        ballot.votes.where(category: self.complementary_category).each do |v|
          comp_votes_array << v
        end
      end
      results_array = []
      has_votes_array.each do |hv|
        vote_hash = {}
        points = 0
        nbr_votes = 0
        votes_array.each do |v|
          if hv.movie_id == v.movie_id && hv.value == v.value
            points = points + v.points
            nbr_votes = nbr_votes + 1
          end
        end
        comp_points = 0
        nbr_comp_votes = 0
        comp_votes_array.each do |cv|
          if cv.value == hv.value && cv.movie_id == hv.movie_id
            comp_points = comp_points + cv.points
            nbr_comp_votes = nbr_comp_votes + 1
          end
        end
        if comp_points < points ||
          (comp_points == points && nbr_comp_votes < nbr_votes) ||
          (nbr_comp_votes == nbr_votes && comp_points == points && (self.name == "actress" || self.name == "actor"))
          points = points + comp_points
          nbr_votes = nbr_votes + nbr_comp_votes
          vote_hash[:value] = hv.value
          vote_hash[:movie] = hv.movie.title
          vote_hash[:points] = points
          vote_hash[:nbr_votes] = nbr_votes
          results_array << vote_hash
        end
      end
    else
      results_array = []
      has_votes_array.each do |hv|
        vote_hash = {}
        points = 0
        nbr_votes = 0
        votes_array.each do |v|
          if hv.movie_id == v.movie_id
            points = points + v.points
            nbr_votes = nbr_votes + 1
          end
          if self.name == "director"
            director_name = hv.movie.director_name
            if director_name
              vote_hash[:value] = director_name
            else
              vote_hash[:value] = ''
            end
          elsif self.name == "screenplay"
            screenwriter_name = hv.movie.screenwriter_name
            if screenwriter_name
              vote_hash[:value] = screenwriter_name
            else
              vote_hash[:value] = ''
            end
          else
            vote_hash[:value] = ''
          end
        end
        vote_hash[:movie] = hv.movie.title
        vote_hash[:points] = points
        vote_hash[:nbr_votes] = nbr_votes
        results_array << vote_hash
      end
    end
    results_array.sort_by! { |x| [x[:points], x[:nbr_votes]] }.reverse!
    results_array
  end


  # def results_in_order(year)
  #   ballots = Ballot.where(year: year, complete: true).all
  #   votes_array = []
  #   ballots.each do |ballot|
  #     ballot.votes.where(category: self).each do |v|
  #       votes_array << v
  #     end
  #   end
  #   if self.is_acting_category || self.name == "scene"
  #     comp_votes_array = []
  #     ballots.each do |ballot|
  #       ballot.votes.where(category: self.complementary_category).each do |v|
  #         comp_votes_array << v
  #       end
  #     end
  #     votes_values_counted = []
  #     results_array = []
  #     votes_array.each do |v1|
  #       vote_hash = {}
  #       points = v1.points
  #       nbr_votes = 1
  #       votes_array.each do |v2|
  #         if v1 != v2 && v1.value == v2.value && v1.movie_id == v2.movie_id
  #           points = points + v2.points
  #           nbr_votes = nbr_votes + 1
  #           votes_array.delete(v2)
  #         end
  #       end
  #       comp_points = 0
  #       nbr_comp_votes = 0
  #       comp_votes_array.each do |cv|
  #         if v1.value == cv.value && v1.movie_id == cv.movie_id
  #           comp_points = comp_points + cv.points
  #           nbr_comp_votes = nbr_comp_votes + 1
  #           comp_votes_array.delete(cv)
  #         end
  #       end
  #       if nbr_comp_votes < nbr_votes ||
  #         (nbr_comp_votes == nbr_votes && comp_points < points) ||
  #         (nbr_comp_votes == nbr_votes && comp_points == points && (self.name == "actress" || self.name == "actor"))
  #         points = points + comp_points
  #         nbr_votes = nbr_votes + nbr_comp_votes
  #         vote_hash[:value] = v1.value
  #         vote_hash[:movie] = v1.movie.title
  #         vote_hash[:points] = points
  #         vote_hash[:nbr_votes] = nbr_votes
  #         results_array << vote_hash
  #       end
  #     end
  #   else
  #     votes_values_counted = []
  #     results_array = []
  #     votes_array.each do |v1|
  #       vote_hash = {}
  #       points = v1.points
  #       nbr_votes = 1
  #       puts "v1: " + v1.movie.title + " " + v1.id.to_s
  #       puts "points: " + v1.points.to_s
  #       votes_array.each do |v2|
  #         if v2.id == 24587
  #           puts "its 24587"
  #         end
  #         if v1 != v2 && v1.movie_id == v2.movie_id
  #           puts "v2: " + v2.movie.title + " " + v2.id.to_s
  #           puts "points: " + v2.points.to_s
  #           points = points + v2.points
  #           nbr_votes = nbr_votes + 1
  #           votes_array.delete(v2)
  #         end
  #       end
  #       if self.name == "director"
  #         director_name = v1.movie.director_name
  #         if director_name
  #           vote_hash[:value] = director_name
  #         else
  #           vote_hash[:value] = ''
  #         end
  #       elsif self.name == "screenplay"
  #         screenwriter_name = v1.movie.screenwriter_name
  #         if screenwriter_name
  #           vote_hash[:value] = screenwriter_name
  #         else
  #           vote_hash[:value] = ''
  #         end
  #       else
  #         vote_hash[:value] = ''
  #       end
  #       vote_hash[:movie] = v1.movie.title
  #       vote_hash[:points] = points
  #       vote_hash[:nbr_votes] = nbr_votes
  #       results_array << vote_hash
  #     end
  #   end
  #   # results_array.sort! { |x,y| y["points"].to_i <=> x["points"].to_i }
  #   results_array.sort_by! { |x| [x[:points], x[:nbr_votes]] }.reverse!
  #   results_array
  # end
end
