#! /bin/bash
application="shipping"

source ./common.sh

root_userCheck

app_setup

java_setup

systemd_setup

echo "please provide mysql root password"
read -s MYSQL_PASSWORD


mysql -h mysql.anantya.space -u root -p$MYSQL_PASSWORD -e 'use cities' &>>$file_path
if [ $? -ne 0 ]
then
    mysql -h mysql.anantya.space -uroot -p$MYSQL_PASSWORD < /app/db/schema.sql &>> $file_path
    mysql -h mysql.anantya.space -uroot -p$MYSQL_PASSWORD < /app/db/app-user.sql &>> $file_path
    mysql -h mysql.anantya.space -uroot -p$MYSQL_PASSWORD < /app/db/master-data.sql  &>> $file_path
    validate $? "Loading data into mysql"
else
    echo "Data is already loaded to mysql database"
fi        


systemctl restart shipping  &>> $file_path
validate $? "restarting shipping"


print_time