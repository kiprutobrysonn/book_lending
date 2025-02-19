
require "test_helper"

class BorrowingTest < ActiveSupport::TestCase
  def setup
    @user = users(:one)
    @book = books(:one)
    @borrowing = Borrowing.new(user: @user, book: @book)
  end

  test "should be valid with valid attributes" do
    assert @borrowing.valid?
  end

  test "should not be valid without due_date" do
    @borrowing.due_date = nil
    assert_not @borrowing.valid?
    assert_includes @borrowing.errors[:due_date], "can't be blank"
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

  test "should not be overdue if returned" do
    @borrowing.due_date = 1.day.ago
    @borrowing.return!
    assert_not @borrowing.overdue?
  end
  test "should mark borrowing as returned" do
    @borrowing.save!
    @borrowing.return!

    assert_not_nil @borrowing.returned_at
  end
end
