#!/bin/bash

ID=$(id -u)
Rm"\e[31m"
Gm"\e[32m"
Ym"\e[33m"
Nm"\e[0m"

TIMESTAMP=$(date +%F-%H-%M-%S)
LOGFILE="/tmp/$0-$TIMESTAMP.log"

echo "script stareted executing at $TIMESTAMP" &>> $LOGFILE

echo "Script started executing at $TIMESTAMP" &>> $LOGFILE
VALIDATE(){
    if[ $1 -ne 0 ]
    
        echo -e "$2 ... $R FAILED $N"
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

if [ $ID -ne 0 ] 
then
    echo"$R ERROR: : Please run this script with root access $N"
    exit 1 # you can give other than 0
    else
        echo "You are root user"
    fi # fi means reverse of if, indicating condition end

    cp mongo.repo /etc/yum.repos.d/mongo.repo &>> $LOGFILE

    VALIDATE $? "Copied MongoDB Repo"

dnf install mongodb-org -y &>> $LOGFILE

VALIDATE$? "Installing MongoDB"

systemctl enable mongod &>> $LOGFILE

VALIDATE$? "Enabling MongoDB"

systemctl start mongod &>> $LOGFILE

VALIDATE$? "Starting MongoDB"

sed -i 's/127.0.0.1/0.0.0.0/g' /etc/mongod.conf &>> $LOGFILE

VALIDATE$? "Remote access to MongoDB"

systemctl restart mongod &>> $LOGFILE

VALIDATE $? "Restarting MongoDB"