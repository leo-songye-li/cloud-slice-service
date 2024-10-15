#!/bin/bash

JOB_ID=$1
CALLBACK=$2

param_resp=$(curl "$CALLBACK?jobId=$JOB_ID&progress=1")
echo "SRC_FILE=123" >> $GITHUB_OUTPUT
echo "::add-mask::$SRC_FILE"
