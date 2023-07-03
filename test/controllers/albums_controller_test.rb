require "test_helper"

class AlbumsControllerTest < ActionDispatch::IntegrationTest
  test "should get feed" do
    get albums_feed_url
    assert_response :success
  end

  test "should get discovery" do
    get albums_discovery_url
    assert_response :success
  end

  test "should get create" do
    get albums_create_url
    assert_response :success
  end

  test "should get update" do
    get albums_update_url
    assert_response :success
  end

  test "should get delete" do
    get albums_delete_url
    assert_response :success
  end
end
