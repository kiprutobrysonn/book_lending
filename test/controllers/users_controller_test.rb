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


  test "user_params permits only allowed parameters" do
    @controller = UsersController.new
    params = ActionController::Parameters.new(
      user: {
        email_address: "test@example.com",
        password: "password123",
        password_confirmation: "password123",
        admin: true # unpermitted param
      }
    )

    @controller.params = params

    filtered_params = @controller.send(:user_params)

    assert_equal [ "email_address", "password", "password_confirmation" ],
                 filtered_params.keys
    assert_not filtered_params.key?("admin")
  end

  test "user_params requires user parameter namespace" do
    @controller = UsersController.new
    params = ActionController::Parameters.new(
      email_address: "test@example.com",
      password: "password123"
    )

    @controller.params = params

    assert_raises(ActionController::ParameterMissing) do
      @controller.send(:user_params)
    end
  end

  test "user_params handles empty parameters" do
    @controller = UsersController.new
    params = ActionController::Parameters.new({})

    @controller.params = params

    assert_raises(ActionController::ParameterMissing) do
      @controller.send(:user_params)
    end
  end
end
