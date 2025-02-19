require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should validate presence of email" do
  user = User.new(password: "password123")
  assert_not user.valid?
  assert_includes user.errors[:email_address], "can't be blank"
  end

  test "should validate uniqueness of email" do
  existing_user = User.create!(email_address: "test@example.com", password: "password123")
  user = User.new(email_address: "test@example.com", password: "password123")
  assert_not user.valid?
  assert_includes user.errors[:email_address], "has already been taken"
  end

  test "should normalize email address" do
  user = User.create!(email_address: " Test@EXAMPLE.com ", password: "password123")
  assert_equal "test@example.com", user.email_address
  end

  test "should have many sessions" do
  assert_respond_to User.new, :sessions
  assert_equal User.reflect_on_association(:sessions).macro, :has_many
  end

  test "should have many borrowings" do
  assert_respond_to User.new, :borrowings
  assert_equal User.reflect_on_association(:borrowings).macro, :has_many
  end

  test "should have many books through borrowings" do
  assert_respond_to User.new, :books
  assert_equal User.reflect_on_association(:books).macro, :has_many
  assert_equal User.reflect_on_association(:books).options[:through], :borrowings
  end

  test "should have many user_roles" do
  assert_respond_to User.new, :user_roles
  assert_equal User.reflect_on_association(:user_roles).macro, :has_many
  end

  test "should have many roles through user_roles" do
  assert_respond_to User.new, :roles
  assert_equal User.reflect_on_association(:roles).macro, :has_many
  assert_equal User.reflect_on_association(:roles).options[:through], :user_roles
  end

  test "should not allow email with invalid format" do
  user = User.new(email_address: "invalid_email", password: "password123")
  assert_not user.valid?
  assert_includes user.errors[:email_address], "is invalid"
  end


  test "should return currently borrowed books" do
  user = users(:one)
  book = books(:one)
  borrowing = borrowings(:one)
  borrowing.update(user: user, book: book, returned_at: nil)
  assert_includes user.currently_borrowed_books, book
  end

  test "should check if user has a specific role" do
  user = users(:one)
  role = roles(:one)
  user.roles << role
  assert user.has_role?(role.name)
  end
end
