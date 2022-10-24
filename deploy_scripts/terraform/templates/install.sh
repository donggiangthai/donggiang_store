#!/bin/bash
sudo apt update
sudo apt upgrade -y
sudo apt install \
python3-pip \
python3-virtualenv \
mysql-server \
python3-dev \
default-libmysqlclient-dev \
build-essential \
libpangocairo-1.0-0 \
-y
sudo systemctl start mysql.service