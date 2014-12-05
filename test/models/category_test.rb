require 'test_helper'

class CategoryTest < ActiveSupport::TestCase

  def setup
    @category = Category.new(name: "best picture")
  end

  test "should be valid" do
    assert @category.valid?
  end

  test "name should be present" do
    @category.name = "  "
    assert_not @category.valid?
  end

  test "correct complementary category should be determined" do
    @category.name = "actress"
    assert_equal @category.complementary_category.name, "supporting actress"
  end
end
