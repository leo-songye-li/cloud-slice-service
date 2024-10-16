#!/bin/bash

JOB_ID=$1
CALLBACK=$2

SRC="1"
echo "::add-mask::$SRC"
# SRC_FILE="234"
# param_resp=$(curl "$CALLBACK?jobId=$JOB_ID&progress=1")
echo "SRC_FILE=$SRC" >> $GITHUB_ENV
