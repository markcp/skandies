require 'test_helper'

class PersonTest < ActiveSupport::TestCase

  def setup
    @year = Year.new(name: '2014', open_voting: Time.now,
                     close_voting: Time.now + 1.month,
                     display_results: Time.now + 2.months)
  end
