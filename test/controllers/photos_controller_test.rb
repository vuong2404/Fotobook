require "test_helper"

class PhotosControllerTest < ActionDispatch::IntegrationTest
  test "should get edit" do
    get photos_edit_url
    assert_response :success
  end

  test "should get destroy" do
    get photos_destroy_url
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

  test "should get new" do
    get photos_new_url
    assert_response :success
  end
end
