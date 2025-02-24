
require "test_helper"

class BorrowingTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @book = books(:three)
    @borrowing = Borrowing.new(user: @user, book: @book)
  end

  test "should be valid with valid attributes" do
    assert @borrowing.valid?
  end
  test "should set due_date before validation on create" do
    @borrowing.valid?
    assert_not_nil @borrowing.due_date
  end


  test "should return active borrowings" do
    assert_includes Borrowing.active, borrowings(:one)
  end
  test "should be overdue if past due date and not returned" do
    @borrowing.due_date = 1.day.ago
    assert @borrowing.overdue?
  end

  test "should  be overdue if returned late" do
    @borrowing.due_date = 1.day.ago
    @borrowing.return!
    assert_not @borrowing.overdue?
  end
end
