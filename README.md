# donggiang_store
Đổng Giang store

###Step 1: _Clone this project_

###Step 2: _Create .env file and put your info like this_:

```
AWS_ACCESS_KEY_ID=your_access_key  
AWS_SECRET_ACCESS_KEY=your_secret_key  
AWS_STORAGE_BUCKET_NAME=your_bucket_name  
USE_S3=True_or_False  
NAME_DB=your_db_name  
USER_DB=your_db_user  
PASSWORD_DB=your_db_password  
HOST_DB=your_db_host  
SECRET_KEY=your_django_secret_key  
```

###Step 3: _Create your own virtual environment and all requirements tool_:  
- Create virtual environment: `virtualenv venv -p python3.8`  
- In case you don't have virtualenv then you can install by using pip: `pip install virtualenv` And then re-run virtualenv command to create virtual environment.  
- Activate your virtual environment:  
    + Window: `.\venv\Scripts\activate`  
    + Linux: `source ./venv/*/bin/activate`  
- Install all requirements needed: `pip install -r requirements.txt`

###Step 4: _Let's migrate database_:  
```python3 manage.py migrate```

###Step 5: _Runserver_:  
- Create superuser for admin site login and editing: `python3 manage.py createsuperuser`  
- Run server: `python3 manage.py runserver`

###Step 6: _Redis and Celery for asynchronous send mail_:  
- You can run Redis server on docker:  
``` docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 redis/redis-stack:latest```  
Visit [Redis Developer - Redis on Docker](https://developer.redis.com/create/docker/redis-on-docker/) for more information and configuration.  
- Open another console and move into project directory then running Celery server for asynchronous task: `celery -A store worker -l INFO -P gevent`  
- Whenever you have completed checkout you will see an email notification for your order.