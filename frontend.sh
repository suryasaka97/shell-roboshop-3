#! /bin/bash

application="nginx"

source ./common.sh

root_userCheck

dnf module disable nginx -y &>>$file_path
dnf module enable nginx:1.24 -y  &>>$file_path
dnf install nginx -y  &>>$file_path
validate $? "Installing Nginx"

rm -rf /usr/share/nginx/html/* &>>$file_path
validate $? "removing Default content"

cp $script_path/nginx.conf /etc/nginx/nginx.conf
validate $? "copying nginx.conf file"

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip  &>>$file_path
validate $? "Downloading frontendcontent"

cd /usr/share/nginx/html &>>$file_path
unzip /tmp/frontend.zip  &>>$file_path
validate $? "Extracting the frontend content"

systemctl enable nginx &>>$file_path
systemctl start nginx  &>>$file_path
validate $? "Starting Nginx"

print_time