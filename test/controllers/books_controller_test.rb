require "test_helper"

class BooksControllerTest < ActionDispatch::IntegrationTest
  setup do
    @book = books(:one)
    @user = users(:one)
    @admin = users(:admin)
    sign_in @user
  end

  test "should get index" do
    get books_url
    assert_response :success
    assert_not_nil assigns(:books)
  end

  test "should show book" do
    get book_url(@book)
    assert_response :success
    assert_not_nil assigns(:book)
  end

  test "should borrow book if available" do
    @book.update(available: true)
    post borrow_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "Book was successfully borrowed.", flash[:notice]
  end

  test "should not borrow book if not available" do
    @book.update(available: false)
    post borrow_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "Book is not available for borrowing.", flash[:alert]
  end

  test "should return book if borrowed by current user" do
    borrowing = borrowings(:one)
    borrowing.update(user: @user, book: @book)
    post return_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "Book was successfully returned.", flash[:notice]
  end

  test "should not return book if not borrowed by current user" do
    borrowing = borrowings(:one)
    borrowing.update(user: users(:two), book: @book)
    post return_book_url(@book)
    assert_redirected_to book_url(@book)
    assert_equal "You cannot return this book. You arent the borrower.", flash[:alert]
  end

  test "should not allow non-admin to perform admin actions" do
    sign_in users(:two)
    delete book_url(@book)
    assert_redirected_to books_url
    assert_equal "You are not authorized to perform this action.", flash[:alert]
  end
end
