#!/bin/bash
JOB_ID=$1
CALLBACK=$2
PROGRESS=$3
FILE_NAME=$4
PARAM=""

if [ -n "$FILE_NAME" ]; then
    if ! [[ "$PROGRESS" =~ ^[0-9]+$ ]]; then
        res=$(curl -X POST -H "Content-Type: application/json" -d "{\"jobId\":\"$JOB_ID\",\"progress\": -1,\"error\": \"$PROGRESS\"}" $CALLBACK)
        exit 1
    fi
    if [ "$PROGRESS" -eq "100" ]; then
        PARAM="{\"jobId\": \"$JOB_ID\", \"progress\": $PROGRESS , \"file\": \"$FILE_NAME\" }"
    fi
else
    PARAM="{\"jobId\": \"$JOB_ID\", \"progress\": $PROGRESS }"
fi

param_resp=$(curl -X POST -H "Content-Type: application/json" -d "{\"jobId\": \"$JOB_ID\", \"progress\": $PROGRESS}" $CALLBACK)
code=$(echo $param_resp | jq -r .code)
if [ $code -eq "200" ]; then
    if [ -z "$SRC_FILE" ]; then
        SRC=$(echo $param_resp | jq -r .data.src)
        if [ -z "$SRC" ]; then
            res=$(curl -X POST -H "Content-Type: application/json" -d "{\"jobId\":\"$JOB_ID\",\"progress\": $PROGRESS,\"error\": \"Resp Src Is Null\"}" $CALLBACK)
            exit 1
        else
            echo "::add-mask::$SRC"
            echo "SRC_FILE=$SRC" >> $GITHUB_ENV
        fi
    else
        echo "$SRC_FILE"
    fi
else
    error=$(echo $param_resp | jq -r .msg)
    res=$(curl -X POST -H "Content-Type: application/json" -d "{\"jobId\":\"$JOB_ID\",\"progress\": $PROGRESS,\"error\": \"Get src failed,CODE=$code,Msg=$error\"}" $CALLBACK)
    exit 1
fi
exit 0
