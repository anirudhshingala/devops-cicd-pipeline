#!/bin/bash

RUNNER_TOKEN=$(curl -sX POST -H "Authorization: token ${GITHUB_PAT}" \
  https://api.github.com/repos/${GITHUB_OWNER_REPO}/actions/runners/registration-token \
  | jq .token --raw-output)

./config.sh --url https://github.com/${GITHUB_OWNER_REPO} --token ${RUNNER_TOKEN} --name ${HOSTNAME} --labels self-hosted,cicd-python --replace --unattended --runasservice

cleanup() {
  ./config.sh remove --unattended --token ${TOKEN}
}

deregister_runner() {
  echo "Deregistering Runner"
  ./config.sh remove --unattended --token ${TOKEN}
}

trap 'deregister_runner; exit 130' SIGTERM
trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
