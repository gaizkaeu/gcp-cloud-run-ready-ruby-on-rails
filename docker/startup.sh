#! /bin/sh

echo "Starting ..."
echo "Git commit: $COMMIT_VERSION - $COMMIT_TIME"
echo "----------------"


# Create or migrate database
echo "Preparing database..."
#bin/rails db:prepare
echo "Database is ready!"

exec "$@"

