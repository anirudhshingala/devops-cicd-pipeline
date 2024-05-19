#!/bin/bash

RUNNER_TOKEN=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" \
  https://api.github.com/repos/${GITHUB_OWNER_REPO}/actions/runners/registration-token \
  | jq .token --raw-output)

echo $RUNNER_TOKEN
