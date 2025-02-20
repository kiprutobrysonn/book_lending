require "test_helper"
class RoleTest < ActiveSupport::TestCase
  setup do
    @role = Role.new(name: "admin")
  end

  test "should create valid role" do
    assert @role.valid?
  end

  test "should have user_roles association" do
    assert_respond_to @role, :user_roles
    assert_kind_of ActiveRecord::Associations::CollectionProxy, @role.user_roles
  end

  test "should have users association" do
    assert_respond_to @role, :users
    assert_kind_of ActiveRecord::Associations::CollectionProxy, @role.users
  end

  test "should be able to add users" do
    user = users(:one)
    @role.save
    @role.users << user
    assert_includes @role.users, user
  end

  test "should destroy associated user_roles when role is destroyed" do
    @role.save
    user = User.new(email_address: "test@example.com", password: "password123")
    @role.users << user

    assert_difference "UserRole.count", -1 do
      @role.destroy
    end
  end
end
