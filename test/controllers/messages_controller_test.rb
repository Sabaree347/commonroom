require "test_helper"

class MessagesControllerTest < ActionDispatch::IntegrationTest
  include Devise::Test::IntegrationHelpers

  test "redirects guests to sign in" do
    get root_url

    assert_redirected_to new_user_session_url
  end

  test "shows the shared room and its messages" do
    sign_in users(:one)
    get root_url

    assert_response :success
    assert_select "h1", "The Commons"
    assert_select "#chat_room article.message", count: 2
  end

  test "creates a message for the signed-in user" do
    sign_in users(:one)

    assert_difference("Message.count", 1) do
      post messages_url, params: { message: { content: "Hello, everyone" } }
    end

    assert_response :see_other
    assert_redirected_to messages_url
    assert_equal users(:one), Message.order(:created_at).last.user
  end

  test "shows validation errors for blank messages" do
    sign_in users(:one)

    assert_no_difference("Message.count") do
      post messages_url, params: { message: { content: " " } }
    end

    assert_response :unprocessable_entity
    assert_select ".form-error"
  end
end
