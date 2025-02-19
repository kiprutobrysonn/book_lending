# db/seeds.rb

# Clear existing data
puts "Cleaning database..."
Borrowing.destroy_all
Book.destroy_all
User.destroy_all

# Create admin user
puts "Creating role "
# db/seeds.rb
Role.create(name: 'admin')
Role.create(name: 'user')


puts "Creating admin user..."
admin = User.create!(
  email_address: "admin@library.com",
  password: "password123",
)
admin.roles << Role.find_by(name: 'admin')


# Create regular users
puts "Creating regular users..."
users = [
  {
    email_address: "john@example.com",
    password: "password123"
  },
  {
    email_address: "jane@example.com",
    password: "password123"
  }
].map { |user_attrs| User.create!(user_attrs) }
for user in users
  user.roles << Role.find_by(name: 'user')
end

# Create books
puts "Creating books..."
books = [
  {
    title: "The Great Gatsby",
    author: "F. Scott Fitzgerald",
    isbn: "978-0743273565",
    description: "A story of the fabulously wealthy Jay Gatsby and his love for the beautiful Daisy Buchanan.",
    publisher: "Scribner",
    publication_year: 1925,
    language: "English"
  },
  {
    title: "To Kill a Mockingbird",
    author: "Harper Lee",
    isbn: "978-0446310789",
    description: "The story of racial injustice and the loss of innocence in the American South.",
    publisher: "Grand Central Publishing",
    publication_year: 1960,
    language: "English"
  },
  {
    title: "1984",
    author: "George Orwell",
    isbn: "978-0451524935",
    description: "A dystopian social science fiction novel and cautionary tale.",
    publisher: "Signet Classic",
    publication_year: 1949,
    language: "English"
  },
  {
    title: "Pride and Prejudice",
    author: "Jane Austen",
    isbn: "978-0141439518",
    description: "The story follows the main character Elizabeth Bennet as she deals with issues of manners, upbringing, morality, education, and marriage.",
    publisher: "Penguin Classics",
    publication_year: 1813,
    language: "English"
  },
  {
    title: "The Hobbit",
    author: "J.R.R. Tolkien",
    isbn: "978-0547928227",
    description: "The adventure of Bilbo Baggins, a hobbit who enjoys a comfortable life until he is swept into an epic quest.",
    publisher: "Houghton Mifflin",
    publication_year: 1937,
    language: "English"
  }
].map { |book_attrs| Book.create!(book_attrs) }

# Create some borrowings
puts "Creating borrowings..."
# Current borrowings
Borrowing.create!(
  user: users[0],
  book: books[0],
  due_date: 2.weeks.from_now
)

Borrowing.create!(
  user: users[1],
  book: books[1],
  due_date: 2.weeks.from_now
)

# Historical borrowings (already returned)
Borrowing.create!(
  user: users[0],
  book: books[2],
  due_date: 2.weeks.ago,
  returned_at: 1.week.ago
)

Borrowing.create!(
  user: users[1],
  book: books[3],
  due_date: 3.weeks.ago,
  returned_at: 4.weeks.ago
)

# Overdue borrowing
Borrowing.create!(
  user: users[0],
  book: books[4],
  due_date: 1.week.ago
)

puts "Seed data created successfully!"

# Optional: Print summary of created data
puts "\nSummary:"
puts "#{User.count} users created"
puts "#{Book.count} books created"
puts "#{Borrowing.count} borrowings created"
puts "#{Borrowing.where.not(returned_at: nil).count} books returned"
puts "#{Borrowing.where(returned_at: nil).count} books currently borrowed"
