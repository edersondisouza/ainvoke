#!/bin/bash

set -ex

SOURCE_ENV=variables.sh

if ! which docker &> /dev/null; then
    echo Need docker to run
    exit 1
fi

if ! groups | grep -wq docker; then
    echo "Add user to group 'docker'"
    exit 1
fi

if [ ! -f $SOURCE_ENV ]; then
    echo "No 'variables.sh' found"
    exit 1
fi

source $SOURCE_ENV

docker build --network=host --build-arg USER=$USER --build-arg USER_ID=$USER_ID \
   --build-arg GROUP=$GROUP --build-arg GROUP_ID=$GROUP_ID \
   --build-arg CLAUDE_CODE_OAUTH_TOKEN=$CLAUDE_CODE_OAUTH_TOKEN \
   --build-arg COPILOT_GITHUB_TOKEN=$COPILOT_GITHUB_TOKEN \
   --build-arg GIT_EMAIL=$GIT_EMAIL \
   --build-arg GIT_NAME="$GIT_NAME" \
   -t ainvoke --target ainvoke .
