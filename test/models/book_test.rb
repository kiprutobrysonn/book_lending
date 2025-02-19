require "test_helper"

class BookTest < ActiveSupport::TestCase
  def setup
    @book = Book.new(title: "Sample Book", author: "Sample Author", isbn: "123-456-7890")
  end

  test "should be valid with valid attributes" do
    assert @book.valid?
  end

  test "title should be present" do
    @book.title = ""
    assert_not @book.valid?
  end

  test "author should be present" do
    @book.author = ""
    assert_not @book.valid?
  end

  test "isbn should be present" do
    @book.isbn = ""
    assert_not @book.valid?
  end

  test "isbn should be unique" do
    duplicate_book = @book.dup
    @book.save
    assert_not duplicate_book.valid?
  end

  test "isbn should have valid format" do
    invalid_isbns = [ "123", "abc-456-7890", "123-456-789012345678" ]
    invalid_isbns.each do |invalid_isbn|
      @book.isbn = invalid_isbn
      assert_not @book.valid?, "#{invalid_isbn.inspect} should be invalid"
    end
  end

  test "available scope should return available books" do
    available_book = books(:one)
    borrowed_book = books(:two)
    assert_includes Book.available, available_book
    assert_not_includes Book.available, borrowed_book
  end

  test "available? should return true if book is not borrowed" do
    assert @book.available?
  end

  test "available? should return false if book is borrowed" do
    @book.borrowings.create(user: users(:one), active: true)
    assert_not @book.available?
  end

  test "current_borrowing should return the active borrowing" do
    borrowing = @book.borrowings.create(user: users(:one), active: true)
    assert_equal borrowing, @book.current_borrowing
  end
end
