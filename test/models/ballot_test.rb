require 'test_helper'

class BallotTest < ActiveSupport::TestCase

  def setup
    @year = years(:open_year)
    @user = users(:madonna)
    @ballot = @user.ballots.build(year: @year, user: @user)
  end

  test "should be valid" do
    assert @ballot.valid?
  end

end
