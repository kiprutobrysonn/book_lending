# Book Lending Application

## Setup Instructions

### Prerequisites

- Ruby 3.2.0 or higher
- Rails 7.0.0 or higher
- PostgreSQL 12.0 or higher

### Initial Setup

1. Clone the repository

```bash
git clone <repository-url>
cd book_lending
```

2. Install dependencies

```bash
bundle install
```

The application will be available at `http://localhost:3000`

### Running Tests

```bash
# Run all tests
rails test

# Run specific test file
rails test test/models/book_test.rb
```

### System Dependencies

- Ruby: Specified in `.ruby-version`
- Node.js: For JavaScript runtime
- PostgreSQL: For database

### Configuration

1. Copy the example environment file

```bash
cp config/database.yml.example config/database.yml
```

2. Configure Database Settings

```yaml
# config/database.yml
default: &default
  adapter: postgresql
  encoding: unicode
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  username: your_postgres_username
  password: your_postgres_password
  host: localhost

development:
  <<: *default
  database: book_lending_development

test:
  <<: *default
  database: book_lending_test

production:
  <<: *default
  database: book_lending_production
  username: <%= ENV['BOOK_LENDING_DATABASE_USERNAME'] %>
  password: <%= ENV['BOOK_LENDING_DATABASE_PASSWORD'] %>
```

3. Set Database Environment Variables
   For development, you can either:

a. Edit the database.yml directly with your credentials, or
b. Create a `.env` file (recommended):

```bash
echo "POSTGRES_USERNAME=your_username" >> .env
echo "POSTGRES_PASSWORD=your_password" >> .env
```

Note: Make sure to add `.env` to your `.gitignore` file to keep your credentials secure.

4. If using Linux, you might need to configure PostgreSQL user:

```bash
sudo -u postgres createuser -s your_username
sudo -u postgres psql
postgres=# \password your_username
```

- Update database.yml with your PostgreSQL credentials

### Database Setup

```bash
# Create the database
rails db:create

# Run migrations
rails db:scheme:load or
rails db:migrate

# Seed the database (if available)
rails db:seed

### Development

- Run the development server: `rails s`
- Run the console: `rails c`
- Run background jobs (if any): `sidekiq`

### Troubleshooting

If you encounter any issues:

1. Ensure all dependencies are installed
2. Check database.yml configuration
3. Ensure PostgreSQL is running
4. Try `bundle exec rake db:reset`
```
