#!/bin/bash
JOB_ID=$1
CALLBACK=$2

param_resp=$(curl -X POST -H "Content-Type: application/json" -d "{\"jobId\": \"$JOB_ID\", \"progress\": 1}" $CALLBACK)
echo "$param_resp"
code=$(echo $param_resp | jq -r .code)
if [ $code -eq "200" ]
then
    SRC=$(echo $param_resp | jq -r .data.src)
    echo "::add-mask::$SRC"
    echo "SRC_FILE=$SRC" >> $GITHUB_ENV
else
    error=$(echo $param_resp | jq -r .msg)
    res=$(curl -X POST -H "Content-Type: application/json" -d "{\"jobId\":\"$JOB_ID\",\"progress\":1,\"error\": \"Get src failed,CODE=$code,Msg=$error\"}" $CALLBACK)
    exit -1
fi
exit 0
