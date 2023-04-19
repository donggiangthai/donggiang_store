# donggiang_store
# Đổng Giang store

### Step 1: _Clone this project_

### Step 2: _Create .env file and put your info like this_:

```
AWS_ACCESS_KEY_ID=your_access_key
AWS_SECRET_ACCESS_KEY=your_secret_key
AWS_STORAGE_BUCKET_NAME=your_bucket_name
USE_S3=True_or_False
NAME_DB=your_db_name
USER_DB=your_db_user
PASSWORD_DB=your_db_password
HOST_DB=your_db_host
PORT_DB=your_db_port
SECRET_KEY=your_django_secret_key
GOOGLE_SECRET=your-google-client-secret
EMAIL_HOST_USER=your-gmail-with-app-password-set
EMAIL_HOST_PASSWORD=your-app-password
```

### Step 3: _Create your own virtual environment and all requirement tools_:

- Recommend to use with Linux environment.
- For Linux user, install dependencies of:
  - python-dev: `sudo apt install python3-dev`
  - psycopg2: `sudo apt install libpq-dev python3.11-dev postgresql-common`
  - weasyprint: `sudo apt install python3-pip libpango-1.0-0 libharfbuzz0b libpangoft2-1.0-0 libffi-dev libjpeg-dev libopenjp2-7-dev`
- Install virtualenv by using pip: `pip install virtualenv`
- Create virtual environment:
  - For Linux user: `virtualenv ~/.donggiang_store --python python3`
  - For Window user: `virtualenv .donggiang_store --python python3`
- Activate your virtual environment:
    + Window: `.donggiang_store\Scripts\activate`
    + Linux: `. ~/.donggiang_store/bin/activate`
- Install all requirements needed: `pip install -r requirements.txt`
- For the Weasy installation, please follow these instructions carefully: https://doc.courtbouillon.org/weasyprint/stable/first_steps.html#installation

### Step 4: _Let's migrate database_:
- If you're using WSL, it's recommended to follow this instruction to allow connection to PostgreSQL from WSL: 
  https://stackoverflow.com/questions/56824788/how-to-connect-to-windows-postgres-database-from-wsl#:~:text=74-,WSL2,-assigns%20IP%20address
- Verify that you're having the connection to Windows PostgreSQL by
  `psql -h $(grep nameserver /etc/resolv.conf | awk '{print $2}') -p 5432 -U postgres`
- When you're ready, run this command to migrate our database: `python3 manage.py migrate`

### Step 5: _Runserver_:
- Collect static before the Front-end can appear: `python3 manage.py collectstatic`
- Create superuser for admin site login and editing: `python3 manage.py createsuperuser`
- Run server: `python3 manage.py runserver`

### Step 6: _Redis and Celery for asynchronous send mail_:
- You can run Redis server on docker:
``` docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 redis/redis-stack:latest```
Visit [Redis Developer -
  Redis on Docker](https://developer.redis.com/create/docker/redis-on-docker/) for more information and configuration.
- Open another console and move into project directory then running Celery server for asynchronous tasks: `celery -A store worker -l INFO -P gevent`
- Whenever you've completed checkout, you will see an email notification for your order.