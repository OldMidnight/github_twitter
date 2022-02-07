require "test_helper"

class WebhookControllerTest < ActionDispatch::IntegrationTest
  test "should get push" do
    get webhook_push_url
    assert_response :success
  end
end
