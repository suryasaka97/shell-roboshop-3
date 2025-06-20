#!/bin/bash
application="mysql"

source ./common.sh

root_userCheck

dnf install mysql-server -y &>>$file_path
validate $? "Installing mySQL server"

systemctl enable mysqld &>> $file_path
systemctl start mysqld  &>> $file_path
validate $? "starting mysql"

read -sp "please provide roboshop password : " MYSQL_PASSWORD

mysql_secure_installation --set-root-pass $MYSQL_PASSWORD 
validate $? "setting root password"

print_time