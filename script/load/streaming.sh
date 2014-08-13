#!/bin/bash


# - Folder with your performance logs
LOCAL_MDM_DIR_LOGS=/home/hadoop/tmp

# - Folder where is your instalation
REMOTE_SCRIPT_EXEC=/home/hadoop/apps/IBM-MDM-LogAnalyzer

# -Username and IP address
USERNAME=hadoop
IPADDRESS=192.168.150.134

RUN=$1

if [ $# -eq 0 ] ; then
    echo "Usage: ./streaming.sh run"
    exit
fi

while [ 1 ] ; do
    TIME=`date +%s`
    echo $TIME
    cd ${LOCAL_MDM_DIR_LOGS}
    find logs/ -name perfor* -exec cat {} \;|gzip| ssh ${USERNAME}@${IPADDRESS} "gunzip -c |${REMOTE_SCRIPT_EXEC}/script/load/script.sh ${RUN}"
    sleep 5;
done
