require "test_helper"

class NotificationsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get notifications_index_url
    assert_response :success
  end

  test "should get mark_as_read" do
    get notifications_mark_as_read_url
    assert_response :success
  end
end
