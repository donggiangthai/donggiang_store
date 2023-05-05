#!/usr/bin/env bash

if [[ -z $DJANGO_SUPERUSER_EMAIL ]] && [[ -z $DJANGO_SUPERUSER_PASSWORD ]]; then
  ssm_prefix='/donggiang_store'
  if [[ -n $profile ]]; then
    django_superuser_email=$(source ssm-get-parameter.sh $ssm_prefix 'DJANGO_SUPERUSER_EMAIL' "$profile" | tr -d '"')
    django_superuser_password=$(source ssm-get-parameter.sh $ssm_prefix 'DJANGO_SUPERUSER_PASSWORD' "$profile" | tr -d '"')
  else
    django_superuser_email=$(source ssm-get-parameter.sh $ssm_prefix 'DJANGO_SUPERUSER_EMAIL' | tr -d '"')
    django_superuser_password=$(source ssm-get-parameter.sh $ssm_prefix 'DJANGO_SUPERUSER_PASSWORD' | tr -d '"')
  fi
  export DJANGO_SUPERUSER_EMAIL=$django_superuser_email
  export DJANGO_SUPERUSER_PASSWORD=$django_superuser_password
fi

# migration model to database
make django-migration

# Start a celery worker
make celery-start

if [[ -n "$DJANGO_SUPERUSER_EMAIL" ]] && [[ -n "$DJANGO_SUPERUSER_PASSWORD" ]]; then
  python3 manage.py createsuperuser --no-input 2>&1
fi

# Start Django server
make runserver
