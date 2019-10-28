#!/bin/bash


# Temp files created by the container will be erasable by external user
umask 0000
bundle install

echo "\e[33mTrying to execute migrations..."
if bin/rails db:migrate; then
    bin/rails runner db/dev-user.rb
    echo "\e[32mDatabase already created. No need for seeding."
else
    echo "\e[31mMigration failed. Installing database"
    bin/rails db:create
    echo "\e[33mExecuting migrations..."
    bin/rails db:migrate
    echo "\e[32mDatabase just created so let's seed some data..."
    bin/rails db:seed
fi

echo
echo "\e[32mGreat! Please use this user/password to login:"
echo
echo "\e[31madmin@example.org"
echo "\e[31mdecidim123456"
echo
echo "\e[33mStarting rails server..."

# bundle exec puma
# bundle exec rails server
bundle exec rails s -b 0.0.0.0
