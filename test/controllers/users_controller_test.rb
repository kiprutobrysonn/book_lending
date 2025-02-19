require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should create user" do
    assert_difference("User.count") do
      post users_url, params: { user: { email_address: "test@example.com", password: "password", password_confirmation: "password" } }
    end
    assert_redirected_to new_session_path
    assert_equal "Account created successfully!", flash[:notice]
  end

  test "should not create user with invalid params" do
    assert_no_difference("User.count") do
      post users_url, params: { user: { email_address: "invalid", password: "password", password_confirmation: "mismatch" } }
    end
    assert_response :unprocessable_entity
  end
end
