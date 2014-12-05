require 'test_helper'

class YearTest < ActiveSupport::TestCase

  def setup
    @year = Year.new(name: '2014', open_voting: Time.now,
                     close_voting: Time.now + 1.month,
                     display_results: Time.now + 2.months)
  end

  test "should be valid" do
    assert @year.valid?
  end

  test "name should be present" do
    @year.name = "  "
    assert_not @year.valid?
  end

  test "open voting time should be present" do
    @year.open_voting = ""
    assert_not @year.valid?
  end

  test "close voting time should be present" do
    @year.close_voting = ""
    assert_not @year.valid?
  end

  test "display results time should be present" do
    @year.display_results = ""
    assert_not @year.valid?
  end
end
