require "test_helper"

class UserRoleTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @role = roles(:one)
    @user_role = UserRole.new(user: @user, role: @role)
  end

  test "should be valid with user and role" do
    assert @user_role.valid?
  end

  test "should require user" do
    @user_role.user = nil
    assert_not @user_role.valid?
  end

  test "should require role" do
    @user_role.role = nil
    assert_not @user_role.valid?
  end

  test "should belong to user" do
    assert_respond_to @user_role, :user
    assert_equal @user_role.user, @user
  end

  test "should belong to role" do
    assert_respond_to @user_role, :role
    assert_equal @user_role.role, @role
  end

  test "should save valid user_role" do
    assert @user_role.save
  end

  test "should update user_role associations" do
    @user_role.save
    new_user = users(:two)
    @user_role.user = new_user
    assert @user_role.save
    assert_equal @user_role.reload.user, new_user
  end

  test "should destroy user_role" do
    @user_role.save
    assert_difference("UserRole.count", -1) do
      @user_role.destroy
    end
  end
end
