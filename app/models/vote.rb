class Vote < ActiveRecord::Base

  belongs_to :ballot
  belongs_to :category
  belongs_to :credit
  belongs_to :movie
  belongs_to :scene
  belongs_to :category_vote_group

  # validate :correct_voting_object
  validates :ballot, presence: true
  validates :category, presence: true
  validates :points, presence: true, inclusion: { in: 5..30, allow_nil: true, message: 'must be > 5 and < 30' }
  validates :movie_id, presence: true
  validate :value_is_not_blank_if_acting_or_scene_vote

  default_scope { order('points DESC') }

  attr_accessor :vote_movie_id

  def value_is_not_blank_if_acting_or_scene_vote
    if category != Category.best_picture && category != Category.best_director && category != Category.best_screenplay
      errors.add(:value, "can't be blank.") if value.blank?
    end
  end

  def object_display
    if category == Category.best_picture
      movie.title
    elsif category == Category.best_director
      movie.director_name
    elsif category == Category.best_screenplay
      movie.screenwriter_name
    elsif category == Category.best_scene
      if ballot.year_id < 20
        scene.title
      else
        value
      end
    else # acting categories
      value ? value : credit.person.name
    end
  end

  def movie_display
    if category == Category.best_picture
      nil
    elsif category == Category.best_director || category == Category.best_director || category == Category.best_screenplay
      movie.title
    elsif category == Category.best_scene
      movie ? movie.title : scene.movie.title
    else #acting categories
      movie ? movie.title : credit.movie.title
    end
  end

  def self.by_points_and_user_name
    joins(ballot: :user).order("points DESC, users.last_name ASC")
  end

  def self.by_category_and_points_and_user_name(category)
    joins(ballot: :user).where( category: category).order("points DESC, users.last_name ASC")
  end

  def self.by_year_category_movie(year, category)
    votes = []
    Movie.where(year: year).order(:title_index).each do |m|
      votes_in_category = m.votes.where(category: category).all
      if votes_in_category.length > 0
        votes_in_category.each do |v|
          if v.ballot.complete
            votes << v
          end
        end
      end
    end
    votes
  end

  def self.winner_list(year, category)
    winner_list = {}
    ballots = Ballot.where(year: year, complete: true).all
    ballots.each do |ballot|
      ballot.votes.where(category: category) do |v|
        if winner_list.has_key?(v.value)
          winner_list[v.movie.title] = winner_list[v.movie.title] + v.points
        else
          winner_list[v.movie.title] = v.points
        end
      end
    end
  end

  def self.first_name(name)
    name.split[0]
  end

  def self.last_name(name)
    if name.split[2]
      name.split[1] + " " + name.split[2]
    elsif name.split[1]
      name.split[1]
    else
      ""
    end
  end

  def self.convert_votes(category, year)
    ballots = Ballot.where(year: year, complete: true).all
    votes = []
    ballots.each do |ballot|
      ballot.votes.where(category: category).each do |v|
        votes << v
      end
    end
    votes.each do |v|
      puts v.id
      first_name = Vote.first_name(v.value)
      last_name = Vote.last_name(v.value)
      puts first_name
      puts last_name
      if category.id == 3 || category.id == 6
        person = Person.where(first_name: first_name, last_name: last_name, gender: "F").last
      else
        person = Person.where(first_name: first_name, last_name: last_name, gender: "M").last
      end
      if person
        puts "person exists"
        credit = Credit.where(movie_id: v.movie_id, person_id: person.id).last
        if credit
          puts "credit exists"
          v.credit_id = credit.id
          v.save
        else
          puts "credit does not exist"
          c = Credit.new
          c.person_id = person.id
          c.movie_id = v.movie_id
          c.job_id = 1
          c.year_id = year.id 
          c.save
          v.credit_id = c.id
          v.save
        end
      else
        puts "person does not exist"
        p = Person.new
        p.first_name = first_name
        p.last_name = last_name
        if category.id == 3 || category.id == 6
          p.gender = 'F'
        else
          p.gender = 'M'
        end
        p.save
        c = Credit.new
        c.person_id = p.id
        c.movie_id = v.movie_id
        c.job_id = 1
        c.year_id = year.id
        c.save
        v.credit_id = c.id
        v.save
      end
    end
  end

  def self.convert_scene_votes(year)
    ballots = Ballot.where(year: year, complete: true).all
    votes = []
    ballots.each do |ballot|
      ballot.votes.where(category_id: 8).each do |v|
        votes << v
      end
    end
    votes.each do |v|
      puts v.id
      scene = Scene.where(title: v.value, movie_id: v.movie_id).last
      puts v.value
      if scene
        puts "scene exists"
        v.scene_id = scene.id
        v.save
      else
        puts "scene does not exist"
        s = Scene.new
        s.title = v.value
        s.movie_id = v.movie_id
        s.year_id = year.id
        s.save
        v.scene_id = s.id
        v.save
      end
    end
  end

  # def correct_voting_object
  #   if !self.credit_id.blank? && self.movie_id.blank? && self.scene_id.blank? # credit vote (acting)
  #     return true
  #   elsif self.credit_id.blank? && !self.movie_id.blank? && self.scene_id.blank? # movie vote (picture, director or screenplay)
  #     return true
  #   elsif self.credit_id.blank? && self.movie_id.blank? && !self.scene_id.blank? # scene vote
  #     return true
  #   elsif self.credit_id.blank? && self.movie_id.blank? && self.scene_id.blank?
  #     errors.add(:credit_id, "Must have a voting object.")
  #   else
  #     errors.add(:credit_id, "Incorrect voting object.")
  #   end
  # end
end
