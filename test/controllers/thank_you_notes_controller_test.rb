require "test_helper"

class ThankYouNotesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get thank_you_notes_index_url
    assert_response :success
  end
end
