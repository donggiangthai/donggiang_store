# This is the make file for creating and setting up all necessary things to run the project.

setup:
	# Install Virtualenv
	python3.10 -m pip install virtualenv
	# Create the environment under the repo root directory (same path as Makefile)
	# Since the celery only support latest version of Python is Python3.10 therefore we're using it.
	# Because the Makefile running all thing in a separate shell,
	# this is the must to activate the environment manually after setup
	# source ~/.donggiang_store/bin/activate
	virtualenv .donggiang_store --clear --python python3.10
install:
	# Install all dependencies. For Ubuntu/Debian user only:
	# Essential dependencies
	sudo apt-get update --fix-missing \
	&& sudo DEBIAN_FRONTEND=noninteractive apt-get install \
	--quiet --no-install-recommends \
    --fix-broken --show-progress --assume-yes \
    build-essential \
    python3-dev \
    vim

	# For postgres:
	sudo apt-get update --fix-missing \
	&& sudo DEBIAN_FRONTEND=noninteractive apt-get install \
	--quiet --no-install-recommends \
    --fix-broken --show-progress --assume-yes \
	libpq-dev \
    postgresql-common

	# For weasyprint
	sudo apt-get update --fix-missing \
	&& sudo DEBIAN_FRONTEND=noninteractive apt-get install \
  	--quiet --no-install-recommends \
    --fix-broken --show-progress --assume-yes \
    libpango-1.0-0 \
    libharfbuzz0b \
    libpangoft2-1.0-0 \
    libffi-dev \
    libjpeg-dev \
    libopenjp2-7-dev

	# Install project dependencies
	# The Makefile is using for CI/CD therefore we will use cache to decrease the build time
	pip install --upgrade pip \
	&& pip install --require-virtualenv --requirement requirements.txt
test:
	# Lint py scripts
	DJANGO_SETTINGS_MODULE=store.settings pylint --load-plugins pylint_django --disable=R,C,W0611 **/*.py
lint:
	# Lint Dockerfile
	docker run --rm --interactive hadolint/hadolint < Dockerfile
django-migration:
	# Make migrations model
	python3 manage.py makemigrations
	# Migrate database
	python3 manage.py migrate
celery-start:
	# Start a worker
	celery --app=store worker --detach --loglevel=INFO --pool=gevent -n worker@%h
celery-stop:
	# Kill celery worker
	pkill --signal TERM --full 'celery worker'
celery-flower:
	# Start flower server to monitor celery worker
	# Read more about the options at https://flower.readthedocs.io/en/latest/config.html#purge-offline-workers
	celery --app=store flower --purge_offline_workers=1
runserver:
	# Collect static file
	python3 manage.py collectstatic --noinput
	# Run django server
	#python3 manage.py runserver 0.0.0.0:8000
	# Run server with gunicorn
	gunicorn store.wsgi:application --bind 0.0.0.0:8000
all: install django-migration celery-start
