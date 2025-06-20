#!/bin/bash

userID=$(id -u)

start_time=$(date +%s)
##colors##

R="\e[31m"
G="\e[32m"
Y="\e[33m"
N="\e[0m"

Log_Folder="/var/log/roboshop-logs"
file_name=$(echo $0 | cut -d "." -f1)
file_path="$Log_Folder/$file_name.log"
script_path=$PWD


mkdir -p $Log_Folder

echo "you are running this script at $(date)" | tee -a $file_path
 
root_userCheck() {
    if [ $userID -ne 0 ]
    then
        echo -e "$R Not a root user....$Y please run the script with root user$N"  | tee -a $file_path
        exit 1
    else
        echo -e "$G Running with Root...$Y Proceeding...$N" | tee -a $file_path
    fi
}


validate(){
    if [ $1 -ne 0 ]
    then
        echo -e "$R $2 Failed...$Y please check $N" | tee -a $file_path
        exit 1
    else
        echo -e "$G $2 Success...$Y"success"$N" | tee -a $file_path
    fi
}

nodejs_setup() {
    dnf module disable nodejs -y &>>$file_path
    validate $? "Disable default nodejs"

    dnf module enable nodejs:20 -y &>>$file_path
    validate $? "Enable nodejs:20"

    dnf install nodejs -y  &>>$file_path
    validate $? "Installing nodejs"

    npm install  &>>$file_path
    validate $? "Installing NPM"
}

app_setup() {
    id roboshop &>>$file_path
    if [ $? -ne 0 ]
    then
        useradd --system --home /app --shell /sbin/nologin --comment "roboshop system user" roboshop &>>$file_path
        validate $? "Roboshop user created"
    else
        echo -e "$G roboshop user is already exist...$Y"skipping this step"$N" | tee -a $file_path
    fi

    curl -L -o /tmp/$application.zip https://roboshop-artifacts.s3.amazonaws.com/$application-v3.zip &>>$file_path
    validate $? "Downloading Zip file" 

    mkdir -p /app  &>>$file_path
    rm -rf /app/* &>>$file_path
    validate $? "Removing unnecessary files"

    cd /app 
    unzip /tmp/$application.zip  &>>$file_path
    validate $? "unzipping files"
}



systemd_setup() {
    cp $script_path/$application.service /etc/systemd/system/$application.service &>>$file_path
    validate $? "copying service file"

    systemctl daemon-reload &>>$file_path
    validate $? "Reloading the service"

    systemctl enable $application &>>$file_path

    systemctl start $application &>>$file_path
    validate $? "starting $application"
}

print_time() {
    End_time=$(date +%s)
    TOTAL_TIME=$(($End_time-$START_TIME))
    echo -e "Time taken to run this script is : $G $TOTAL_TIME $N seconds" | tee -a $file_path
}