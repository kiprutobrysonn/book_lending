class Book < ApplicationRecord
  has_many :borrowings, dependent: :destroy
  has_many :users, through: :borrowings

  validates :title, presence: true
  validates :author, presence: true
  validates :isbn, presence: true, uniqueness: true, format: { with: /\A[0-9-]{10,17}\z/, message: "Invalid ISBN Format" }




  scope :available, -> { where.not(id: borrowings.active.select(:book_id)) }

  def available?
    !borrowings.active.exists?
  end

  def current_borrowing
    borrowings.active.first
  end
end
