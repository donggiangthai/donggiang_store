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
SECRET_KEY=your_django_secret_key  
```

### Step 3: _Create your own virtual environment and all requirements tool_:  
- Create virtual environment: `virtualenv venv -p python3.8`  
- In case you don't have virtualenv then you can install by using pip: `pip install virtualenv` And then re-run virtualenv command to create virtual environment.  
- Activate your virtual environment:  
    + Window: `.\venv\Scripts\activate`  
    + Linux: `source ./venv/*/bin/activate`  
- Install all requirements needed: `pip install -r requirements.txt`
- If you got an error while install mysqlclient then try this:
    - CenOS
        + `sudo yum install gcc`
        + `sudo yum install python3-devel mysql-devel`
    - Ubuntu:
        + `sudo apt-get install python3-dev default-libmysqlclient-dev build-essential`
    - Then try to run `pip install -r requierments.txt` again
    

### Step 4: _Let's migrate database_:
- Make sure you already have the connection to your database then run the command:  
` python3 manage.py migrate `
- If you got problem with pango please run this command  
    - CenOS: ` sudo yum install pango.x86_64 `
    - Ubuntu: ` sudo apt install libpangocairo-1.0-0 `
- https://aws.amazon.com/premiumsupport/knowledge-center/rds-connect-ec2-bastion-host/
- https://docs.aws.amazon.com/AmazonS3/latest/userguide/WebsiteAccessPermissionsReqd.html#bucket-policy-static-site

### Step 5: _Runserver_:
- Collect static before the Front-end can appear:  
`python3 manage.py collectstatic`
- Create superuser for admin site login and editing:  
`python3 manage.py createsuperuser`  
- Run server:  
`python3 manage.py runserver 0.0.0.0:8080`

### Step 6: _Redis and Celery for asynchronous send mail_:  
- You can run Redis server on docker:  
``` docker run -d --name redis-stack -p 6379:6379 -p 8001:8001 redis/redis-stack:latest```  
Visit [Redis Developer - Redis on Docker](https://developer.redis.com/create/docker/redis-on-docker/) for more information and configuration.  
- Open another console and move into project directory then running Celery server for asynchronous task: `celery -A store worker -l INFO -P gevent`  
- Whenever you have completed checkout you will see an email notification for your order.