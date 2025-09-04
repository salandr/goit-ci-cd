#!/bin/sh

echo "Waiting for PostgreSQL..."

while ! nc -z "$DB_HOST" "$DB_PORT"; do
  sleep 1
done

echo "PostgreSQL is up - applying migrations"

python manage.py migrate
exec python manage.py runserver 0.0.0.0:8000

