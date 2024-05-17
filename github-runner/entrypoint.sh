#!/bin/bash

TOKEN=${RUNNER_TOKEN}
ORG=${GITHUB_ORG}
REPO=${GITHUB_REPO}

./config.sh --url https://github.com/${ORG}/${REPO} --token ${TOKEN}

cleanup() {
  ./config.sh remove --token ${TOKEN}
}

trap 'cleanup; exit 130' INT
trap 'cleanup; exit 143' TERM

./run.sh & wait $!
