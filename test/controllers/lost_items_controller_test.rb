require "test_helper"

class LostItemsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get lost_items_index_url
    assert_response :success
  end

  test "should get new" do
    get lost_items_new_url
    assert_response :success
  end

  test "should get create" do
    get lost_items_create_url
    assert_response :success
  end

  test "should get show" do
    get lost_items_show_url
    assert_response :success
  end
end
