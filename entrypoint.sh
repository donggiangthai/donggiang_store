#!/usr/bin/env bash
if [[ -z $DATABASE_HOST ]] && [[ -z $DATABASE_PORT ]]; then
  ssm_prefix='/donggiang_store'
  if [[ -n $profile ]]; then
    HOST_DB=$(source ssm-get-parameter.sh $ssm_prefix 'DATABASE_HOST' "$profile" | tr -d '"')
    PORT_DB=$(source ssm-get-parameter.sh $ssm_prefix 'DATABASE_PORT' "$profile" | tr -d '"')
  else
    HOST_DB=$(source ssm-get-parameter.sh $ssm_prefix 'DATABASE_HOST' | tr -d '"')
    PORT_DB=$(source ssm-get-parameter.sh $ssm_prefix 'DATABASE_PORT' | tr -d '"')
  fi
else
  HOST_DB=$DATABASE_HOST
  PORT_DB=$DATABASE_PORT
fi

if [[ "$DATABASE" = "postgres" ]]; then
  echo "Waiting for postgres..."

  while ! nc -z "$HOST_DB" "$PORT_DB"; do
    echo "Waiting for postgres: $HOST_DB:$PORT_DB"
    sleep 1
  done

  echo "PostgreSQL started"
fi

exec "$@"
