require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  include Rails::Controller::Testing::TestProcess
  include Rails::Controller::Testing::TemplateAssertions
  include Rails::Controller::Testing::Integration

  setup do
    @book = books(:one)
    @user = users(:one)
    @admin = users(:one)
  end

  test "should get index" do
    user = users(:one)
    post session_url, params: { email_address: user.email_address, password: "password" }
    get books_url
    assert_response :success
    assert_not_nil assigns(:books)
  end

  test "should show book" do
    user = users(:one)
    post session_url, params: { email_address: user.email_address, password: "password" }
    get book_url(@book)
    assert_response :success
    assert_not_nil assigns(:book)
  end

  test "should borrow book if available" do
    user = users(:one)
    post session_url, params: { email_address: user.email_address, password: "password" }
    borrowing = borrowings(:one)
  borrowing.update(returned_at: 1.weeks.ago)
    post borrow_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "Book was successfully borrowed.", flash[:notice]
  end

  test "should not borrow book if not available" do
    user = users(:one)
    post session_url, params: { email_address: user.email_address, password: "password" }
    borrowing = borrowings(:two)
    borrowing.update(user: @user, book: @book)
    post borrow_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "Book is not available for borrowing.", flash[:alert]
  end

  test "should return book if borrowed by current user" do
    user = users(:one)
    post session_url, params: { email_address: user.email_address, password: "password" }
    borrowing = borrowings(:one)
    borrowing.update(user: @user, book: @book)
    post return_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "Book was successfully returned.", flash[:notice]
  end

  test "should not return book if not borrowed by current user" do
    user = users(:two)
    post session_url, params: { email_address: user.email_address, password: "password" }
    follow_redirect!
    borrowing = borrowings(:two)
    borrowing.update(user: users(:one), book: @book)
    post return_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "You cannot return this book. You arent the borrower.", flash[:alert]
  end

  test "should not allow non-admin to perform admin actions" do
    user = users(:two)
    post session_url, params: { email_address: user.email_address, password: "password" }
    delete book_url(@book)
    assert_redirected_to books_url
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end

test "admin should create book with valid params" do
  admin = users(:one)
  post session_url, params: { email_address: admin.email_address, password: "password" }
  assert_difference("Book.count") do
    post books_url, params: {
      book: {
        title: "New Book",
        author: "Author Name",
        isbn: "1234567890",
        publisher: "Publisher",
        publication_year: 2023,
        language: "English"
      }
    }
  end
  assert_redirected_to books_path
  assert_equal "New book added successfully", flash[:notice]
end
end
