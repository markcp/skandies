class CategoryVoteGroup
  include ActiveRecord::Validations
  attr_accessor :votes

  validate :all_votes_okay

  def all_votes_okay
    votes.each do |vote|
      errors.add vote.errors unless vote.valid?
    end
  end

  def save
    votes.all?(&:save)
  end

  def votes=(incoming_data)
    incoming_data.each do |incoming|
       if incoming.respond_to? :attributes
         @votes << incoming unless @votes.include? incoming
       else
         if incoming[:id]
            target = @votes.select { |t| t.id == incoming[:id] }
         end
         if target
            target.attributes = incoming
         else
            @votes << Vote.new incoming
         end
       end
    end
  end

  def votes
     # your photo-find logic here
    @votes || Vote.find :all
  end
end
