#!/bin/bash

application="catalogue.sh"

source ./common.sh

root_userCheck

app_setup

nodejs_setup

systemd_setup


cp $script_path/mongo.repo /etc/yum.repos.d/mongo.repo  &>>$file_path
validate $? "copying mongo repo"

dnf install mongodb-mongosh -y  &>>$file_path
validate $? "installing mongodb client"

STATUS=$(mongosh --host mongodb.anantya.space --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $STATUS -lt 0 ]
then
    mongosh --host mongodb.anantya.space </app/db/master-data.js  &>>$file_path
    validate $? "Loading data into mongodb"
else
    echo -e "data is already loading...$Y"skipping"$N"
fi

print_time