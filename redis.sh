#! /bin/bash

source ./common.sh
application="redis"

root_userCheck

dnf module disable redis -y &>>$file_path
validate $? "Disable default redis module" | tee -a $file_path

dnf module enable redis:7 -y &>>$file_path
validate $? "Enable redis 7"  | tee -a $file_path

dnf install redis -y &>>$file_path
validate $? "Installing redis" | tee -a $file_path


sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf &>>$file_path
validate $? "Using sed changes ip and protected mode"  | tee -a $file_path



systemctl enable redis &>>$file_path
validate $? "Enable redis" | tee -a $file_path

systemctl start redis &>>$file_path
validate $? "Disable redis" | tee -a $file_path

print_time