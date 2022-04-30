#!/bin/bash

#from https://pspdfkit.com/blog/2018/how-to-run-your-phoenix-application-with-docker/

echo "---------- DEPENDENCY FETCH ------------------"
mix deps.get

echo "---------- COMPILE ------------------"
echo "Y" | mix do compile

# Wait until postgres is ready
while ! pg_isready -q -h "$PGHOST" -p "$PGPORT" -U "$PGUSER"
do
    echo "$(date) - waiting for database to start"
    sleep 2
done


# create, migrate, and seed database if it doesn't exist
if [[ -z $(psql -Atqc "\\list $PGDATABASE") ]]; then
    echo "Database $PGDATABASE does not exist. Creating"
    createdb -E UTF8 "$PGDATABASE" -l en_US.UTF-8 -T template0
    mix ecto.migrate
    mix run priv/repo/seeds.exs
    echo "Database $PGDATABASE created" 
fi

exec mix phx.server
