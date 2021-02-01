require 'test_helper'

class MonthsControllerTest < ActionDispatch::IntegrationTest
  test "should get update" do
    get months_update_url
    assert_response :success
  end

end
