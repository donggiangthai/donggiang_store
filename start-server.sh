#!/usr/bin/env bash
# start-server.sh

#source .env

# migration model to database
make django-migration

# Start a celery worker
make celery-start

if [[ -n "$DJANGO_SUPERUSER_EMAIL" ]] && [[ -n "$DJANGO_SUPERUSER_PASSWORD" ]]; then
    python3 manage.py createsuperuser --no-input 2>&1
fi

# Start Django server
make runserver
