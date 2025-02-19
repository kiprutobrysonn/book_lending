class BorrowingsController < ApplicationController
  def create
    book = Book.find(params[:book_id])

    if book.available?
      Borrowing.create(
        user: current_user,
        book: book,
        borrowed_at: Time.now,
        due_date: 2.weeks.from_now
      )
      book.update(borrowed: true)
      redirect_to user_path(current_user), notice: "Book borrowed successfully!"
    else
      redirect_to book, alert: "Book is already borrowed."
    end
  end

  def destroy
  end


  def index
    @borrowings = Current.user.borrowings.active.includes(:book).order(created_at: :desc)
  end

  def history
    @borrowings = current_user.borrowings.includes(:book).order(created_at: :desc)
  end

  def overdue
    @borrowings = current_user.borrowings.overdue.includes(:book)
  end

  # Admin actions
  def all_borrowings
    ensure_admin!
    @borrowings = Borrowing.includes(:user, :book).order(created_at: :desc)
  end

  def all_overdue
    ensure_admin!
    @borrowings = Borrowing.overdue.includes(:user, :book)
  end

  private

  def ensure_admin!
    unless authenticated?&.admin?
      flash[:alert] = "You are not authorized to view this page."
      redirect_to borrowings_path
    end
  end
end




# app/controllers/borrowings_controller.rb
