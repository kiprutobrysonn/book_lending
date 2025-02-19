require "test_helper"

class SessionsControllerTest < ActionDispatch::IntegrationTest
  test "should get new" do
    get new_session_url
    assert_response :success
  end

  test "should create session with valid credentials" do
    user = users(:one)
    post session_url, params: { email_address: user.email_address, password: "password" }
    assert_redirected_to after_authentication_url
  end

  test "should not create session with invalid credentials" do
    post session_url, params: { email_address: "invalid@example.com", password: "wrongpassword" }
    assert_redirected_to new_session_path
    assert_equal "Try another email address or password.", flash[:alert]
  end

  test "should destroy session" do
    delete session_url
    assert_redirected_to new_session_path
  end

  test "should rate limit session creation" do
    10.times do
      post session_url, params: { email_address: "test@example.com", password: "password" }
    end
    post session_url, params: { email_address: "test@example.com", password: "password" }
    assert_redirected_to new_session_url
    assert_equal "Try again later.", flash[:alert]
  end
end
