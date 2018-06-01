#!/bin/bash

SERVICE_NAME=demo
PATH_TO_JAR=/home/ec2-user/demo/demo-0.0.1-SNAPSHOT.jar
PATH_TO_CONFIG=/home/ec2-user/gilada/config.yml <=== SI ES QUE TENES, SUELE SER UN YML
PID_PATH_NAME=/var/log/gilada-pid
export DW_DEFAULT_LOGGING_PATH=/home/ec2-user/gilada
#Default values
MIN_JVM_HEAP_SIZE=-Xms512m
MAX_JVM_HEAP_SIZE=-Xms512m

case $1 in
    start)
        echo "Starting $SERVICE_NAME ..."
        if [ ! -f $PID_PATH_NAME ]; then
            nohup java $MAX_JVM_HEAP_SIZE $MIN_JVM_HEAP_SIZE -jar $PATH_TO_JAR server $PATH_TO_CONFIG </dev/null &>/dev/null &
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is already running ..."
        fi
    ;;
    stop)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stoping ..."
            kill $PID;
            echo "$SERVICE_NAME stopped ..."
            rm $PID_PATH_NAME
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
    restart)
        if [ -f $PID_PATH_NAME ]; then
            PID=$(cat $PID_PATH_NAME);
            echo "$SERVICE_NAME stopping ...";
            kill $PID;
            echo "$SERVICE_NAME stopped ...";
            rm $PID_PATH_NAME
            echo "$SERVICE_NAME starting ..."
            nohup java $MAX_JVM_HEAP_SIZE $MIN_JVM_HEAP_SIZE -jar $PATH_TO_JAR server $PATH_TO_CONFIG </dev/null &>/dev/null &
                        echo $! > $PID_PATH_NAME
            echo "$SERVICE_NAME started ..."
        else
            echo "$SERVICE_NAME is not running ..."
        fi
    ;;
esac