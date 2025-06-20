#!/bin/bash

application="rabbitmq"

source ./common.sh

root_userCheck

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> $file_path
validate $? "copying rabbitmq to yum.repos.d"

dnf install rabbitmq-server -y &>> $file_path
validate $? "Installing rabbitmq server"

systemctl enable rabbitmq-server &>> $file_path
validate $? "Enabling rabbitmq"

systemctl start rabbitmq-server &>> $file_path
validate $? "starting rabbitmq"


rabbitmqctl list_users | grep "^roboshop" &>>$file_name

if [ $? -ne 0 ]
then
    echo "Please enter rabbitmq password to setup"
    read -s RABBITMQ_PASSWD

    rabbitmqctl add_user roboshop $RABBITMQ_PASSWD  &>> $file_path
    validate $? "adding roboshop user"

    rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>> $file_path
    validate $? "settingup permissions"
else
   echo -e  "rabbitmq roboshop user $Y already exists$N"
fi    

print_time