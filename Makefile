# This is the make file for creating and setting up all necessary things to run the project.

setup:
	# Install Virtualenv
	python3.10 -m pip install virtualenv
	# Create the environment under the home directory
	# Since the celery only support latest version of Python is Python3.10 therefore we're using it.
	# Because the Makefile running all thing in a separate shell,
	# this is the must to activate the environment manually after setup
	# source ~/.donggiang_store/bin/activate
	virtualenv ~/.donggiang_store --clear --python python3.10
install:
	# Update and upgrade distribution
	sudo apt-get update \
	&& sudo apt-get upgrade -y
	# Install all dependencies. For Ubuntu/Debian user only:
	# For postgres:
	sudo apt install python3-dev libpq-dev postgresql-common
	# For weasyprint
	sudo apt install python3-pip libpango-1.0-0 libharfbuzz0b libpangoft2-1.0-0 libffi-dev libjpeg-dev libopenjp2-7-dev
	# Install project dependencies
	pip install --upgrade pip && \
	pip install --no-cache-dir --require-virtualenv --requirement requirements.txt
django-migration:
	# Make migrations model
	python3 manage.py makemigrations
	# Migrate database
	python3 manage.py migrate
celery-start:
	# Start a worker
	celery --app=store worker --detach --loglevel=INFO --pool=gevent -n worker@%h
	# Auto reload worker with Watchdog => Cause an increase of CPU utilize, need more research with auto reload celery worker
	# watchmedo auto-restart --directory=./ --pattern=*.py --recursive --signal SIGTERM -- celery --app=store worker --detach --loglevel=INFO --pool gevent -n watchdog@%h
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
	python3 manage.py runserver 0.0.0.0:8000
all: install django-migration celery-start
