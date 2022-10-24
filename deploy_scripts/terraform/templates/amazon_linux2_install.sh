#!/bin/bash
yum update -y
yum install \
git \
gcc \
python3-devel \
mysql-devel \
pango.x86_64 \
-y
pip3 install virtualenv
cd ~
git clone https://github.com/donggiangthai/donggiang_store.git
virtualenv venv -p python3.7
source venv/bin/activate
cd donggiang_store
echo -e \
"NAME_DB=donggiang_store\nSECRET_KEY=your_django_secret_key\n# For AWS setting\nUSE_S3=True\nAWS_ACCESS_KEY_ID=your_AWS_ACCESS_KEY_ID\nAWS_SECRET_ACCESS_KEY=your_AWS_SECRET_ACCESS_KEY\nAWS_STORAGE_BUCKET_NAME=848615702835-devops-practice\nUSER_DB=donggiangthai\nPASSWORD_DB=AdminThaiDG123\nHOST_DB=devops-rds.c3r2qur10kah.us-east-1.rds.amazonaws.com\n" \
> .env
pip install -r requirements.txt
pip install weasyprint
export DJANGO_SUPERUSER_EMAIL=donggiangthai1998@gmail.com
export DJANGO_SUPERUSER_PASSWORD=AdminThaiDG123
python3 manage.py migrate
python3 manage.py createsuperuser --no-input
python3 manage.py collectstatic --no-input
screen -d -m python3 manage.py runserver 0.0.0.0:8080