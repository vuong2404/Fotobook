require "test_helper"

class PhotosControllerTest < ActionDispatch::IntegrationTest
  test "should get feed" do
    get photos_feed_url
    assert_response :success
  end

  test "should get discovery" do
    get photos_discovery_url
    assert_response :success
  end

  test "should get create" do
    get photos_create_url
    assert_response :success
  end

  test "should get update" do
    get photos_update_url
    assert_response :success
  end

  test "should get delete" do
    get photos_delete_url
    assert_response :success
  end
end
