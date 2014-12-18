class CategoryVoteGroupsController < ApplicationController

  def new
    @category_vote_group = CategoryVoteGroup.new
  end
end
