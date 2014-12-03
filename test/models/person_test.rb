require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  def setup
    @person = Person.new(first_name: "Example", last_name: "Actor",
                         gender: "M")
  end

  test "should be valid" do
    assert @person.valid?
  end

  test "should require a last_name" do
    @person.last_name = ""
    assert_not @person.valid?
  end

  test "should require a gender" do
    @person.gender = ""
    assert_not @person.valid?
  end

  test "should require a valid gender" do
    @person.gender = "X"
    assert_not @person.valid?
  end

  test "should require a last_name_first value" do
    @person.last_name_first = nil
    assert_not @person.valid?
  end

  test "name should be first name plus last name" do
    assert_equal @person.name, "Example Actor"
  end

  test "name order should be reversed if required" do
    @person.last_name_first = true
    assert_equal @person.name, "Actor Example"
  end

  test "name should be last name only for people with just a single name" do
    @person.first_name = nil
    assert_equal @person.name, "Actor"
  end
end
