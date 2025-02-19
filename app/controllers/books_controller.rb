class BooksController < ApplicationController
  before_action :set_book, only: [ :show,   :borrow, :return, :edit, :update, :destroy ]
  before_action :ensure_admin!, only: [ :new, :create, :edit, :update, :destroy ]



  def new
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
      if @book.save

        redirect_to books_path, notice: "New book added successfully"
      else
        render :new, status: :unprocessable_entity
      end
  end


  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to @book, notice: "Book was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @book.destroy
    redirect_to books_path, notice: "Book was successfully deleted"
  end



  def index
    @books = Book.all
  end

  def show
    @book = Book.find(params[:id])
  end

  def borrow
    if @book.available?
      #  borrowing=  @current_user.borrowings.create(book: @book)
      #
      user = Current.user
    puts "user is #{user}"

      borrowing = user.borrowings.build(book: @book)

      if borrowing.save
        flash[:notice] = "Book was successfully borrowed."
      else
        flash[:alert] = "Error borrowing book: #{borrowing.errors.full_messages.join(', ')}"
      end
    else
      flash[:alert] = "Book is not available for borrowing."
    end

    redirect_to @book
  end

  def return
    borrowing = @book.current_borrowing

    if borrowing&.user == Current.user
      if borrowing.return!
        flash[:notice] = "Book was successfully returned."
      else
        flash[:alert] = "Error returning book: #{borrowing.errors.full_messages.join(', ')}"
      end
    else
      flash[:alert] = "You cannot return this book. You arent the borrower."
    end

    redirect_to @book
  end

  private
  def set_book
    @book = Book.find(params[:id])
  end



  def book_params
    params.require(:book).permit(:title, :author, :isbn, :description, :publisher, :publication_year, :language)
  end

  def ensure_admin!
    unless current_user&.has_role?("admin")
      flash[:alert] = "You are not authorized to perform this action."
      redirect_to books_path
    end
  end
end
