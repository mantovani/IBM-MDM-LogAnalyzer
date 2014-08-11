#!/bin/bash


#LOCAL_MDM_DIR_LOGS=/opt/IBM/WebSphere/AppServer/profiles/AppSrv01/
LOCAL_MDM_DIR_LOGS=/home/hadoop/tmp
REMOTE_SCRIPT_EXEC=/home/hadoop/apps/IBM-MDM-LogAnalyzer/script/load

RUN=$1

if [ $# -eq 0 ] ; then
    echo "Usage: ./streaming.sh run"
    exit
fi

while [ 1 ] ; do
    TIME=`date +%s`
    echo $TIME
    cd ${LOCAL_MDM_DIR_LOGS}
    find logs/ -name perfor* -exec cat {} \;|gzip| ssh hadoop@192.168.150.134 "gunzip -c |${REMOTE_SCRIPT_EXEC}/script.sh ${RUN}"
    sleep 5;
done
