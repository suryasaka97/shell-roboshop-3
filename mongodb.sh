#! /bin/bash

source ./common.sh
application="mongodb"

root_userCheck

cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $file_path
validate $? "Copying Repo"

dnf install mongodb-org -y &>>$file_path
validate $? mongodb-install

systemctl enable mongod &>>$file_path
validate $? enable

systemctl start mongod &>>$file_path
validate $? start

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>>$file_path
validate $?  "Ip Addreess change"

systemctl restart mongod &>>$file_path
validate $? "restart of mongodb"

print_time