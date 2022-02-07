#!/bin/bash
# Docker entrypoint script.

# Wait until Postgres is ready
while ! pg_isready -q -h $POSTGRES_HOST -p $POSTGRES_PORT -U $POSTGRES_USER
do
  echo "$(date) - waiting for database to start"
  sleep 2
done

make compile
MIX_ENV=dev mix ecto.create
MIX_ENV=test mix ecto.create
make db-update
make run-dev
