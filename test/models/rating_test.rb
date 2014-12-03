require 'test_helper'

class RatingTest < ActiveSupport::TestCase

  def setup
    @rating = Rating.new(ballot_id: 1, movie_id: 1, value: 3.0)
  end

  test "should be valid" do
    assert @rating.valid?
  end

  test "should require a ballot_id" do
    @rating.ballot_id = nil
    assert_not @rating.valid?
  end

  test "should require a movie_id" do
    @rating.movie_id = nil
    assert_not @rating.valid?
  end

  test "should require a value" do
    @rating.value = nil
    assert_not @rating.valid?
  end

  test "should require a valid value" do
    @rating.value = 0.5
    assert_not @rating.valid?
  end
end
