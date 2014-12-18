class VoteGroupsController < ApplicationController

  def new
    @vote_group = VoteGroup.new
  end

end
