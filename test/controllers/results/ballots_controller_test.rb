require 'test_helper'

class Results::BallotsControllerTest < ActionController::TestCase

  test "should get index" do
    get :index
    assert_response :success
  end

  # test "should get show" do
  #   get(:show, { id: 12 })
  #   assert_response :success
  # end
end
