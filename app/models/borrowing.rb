# Represents a borrowing record of a book by a user.
#
# Associations:
# - belongs_to :user
# - belongs_to :book
#
# Validations:
# - due_date: must be present
# - book_must_be_available: custom validation to ensure the book is available, only on create
#
# Scopes:
# - active: returns borrowings that have not been returned
# - overdue: returns active borrowings that are past their due date
#
# Callbacks:
# - before_validation :set_due_date, on: :create
#
# Instance Methods:
# - return!: marks the borrowing as returned by setting the returned_at timestamp to the current time
class Borrowing < ApplicationRecord
  belongs_to :user
  belongs_to :book

  validates :due_date, presence: true
  validate :book_must_be_available, on: :create

  scope :active, -> { where(returned_at: nil) }
  scope :overdue, -> { active.where("due_date < ?", Date.current) }

  before_validation :set_due_date, on: :create


  def return!
    update!(returned_at: Time.current)
  end

  def overdue?
    due_date < Date.current && returned_at
  end

  private

  def set_due_date
    self.due_date ||= 2.weeks.from_now.to_date
  end

  def book_must_be_available
    if book.present? && !book.available? && book.current_borrowing&.id != id
      errors.add(:book, "Sorry the book is not available")
    end
  end
end
