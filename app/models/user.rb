class User < ApplicationRecord
  has_secure_password
  has_many :sessions, dependent: :destroy
  has_many :borrowings, dependent: :destroy
  has_many :books, through: :borrowings
  has_many :user_roles
  has_many :roles, through: :user_roles



  validates :email_address, presence: true, uniqueness: true
  normalizes :email_address, with: ->(e) { e.strip.downcase }
  validates :email_address, format: { with: URI::MailTo::EMAIL_REGEXP, message: "is invalid" }


  def currently_borrowed_books
    books.joins(:borrowings).where(borrowings: { returned_at: nil }).distinct
  end

  def has_role?(role_name)
    roles.exists?(name: role_name)
  end
end
