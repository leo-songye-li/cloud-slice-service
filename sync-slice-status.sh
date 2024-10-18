#!/bin/bash
JOB_ID=$1
CALLBACK=$2
PROGRESS=$3
FILENAME=$4
PARAM=""

if [ -n "$4" ]; then
    if [ "$PROGRESS" -eq "100" ]; then
        PARAM="{\"jobId\": \"$JOB_ID\", \"progress\": $PROGRESS , \"file\": \"$FILENAME\" }"
    fi
else
    PARAM="{\"jobId\": \"$JOB_ID\", \"progress\": $PROGRESS }"
fi

param_resp=$(curl -X POST -H "Content-Type: application/json" -d "{\"jobId\": \"$JOB_ID\", \"progress\": $PROGRESS}" $CALLBACK)
code=$(echo $param_resp | jq -r .code)
if [ $code -eq "200" ]; then
    if [ -z "$SRC_FILE" ]; then
        SRC=$(echo $param_resp | jq -r .data.src)
        # echo "::add-mask::$SRC"
        echo "SRC_FILE=$SRC" >> $GITHUB_ENV
    else
        echo "$SRC_FILE"
    fi
else
    error=$(echo $param_resp | jq -r .msg)
    res=$(curl -X POST -H "Content-Type: application/json" -d "{\"jobId\":\"$JOB_ID\",\"progress\": $PROGRESS,\"error\": \"Get src failed,CODE=$code,Msg=$error\"}" $CALLBACK)
    exit -1
fi
exit 0
