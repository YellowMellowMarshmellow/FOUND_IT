require "test_helper"

class FoundItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get found_items_index_url
    assert_response :success
  end

  test "should get show" do
    get found_items_show_url
    assert_response :success
  end

  test "should get new" do
    get found_items_new_url
    assert_response :success
  end

  test "should get create" do
    get found_items_create_url
    assert_response :success
  end

  test "should get update" do
    get found_items_update_url
    assert_response :success
  end

  test "should get destroy" do
    get found_items_destroy_url
    assert_response :success
  end
end
