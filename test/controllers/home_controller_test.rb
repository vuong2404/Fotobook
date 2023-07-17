require "test_helper"

class HomeControllerTest < ActionDispatch::IntegrationTest
  test "should get feed" do
    get home_feed_url
    assert_response :success
  end

  test "should get discovery" do
    get home_discovery_url
    assert_response :success
  end
end
