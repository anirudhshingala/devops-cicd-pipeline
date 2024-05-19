FROM ubuntu:20.04

ARG GITHUB_TOKEN
ARG GITHUB_REPOSITORY

ENV DEBIAN_FRONTEND=noninteractive
ENV RUNNER_ALLOW_RUNASROOT="1"
ENV GITHUB_PAT=${GITHUB_TOKEN}
ENV GITHUB_OWNER_REPO=${GITHUB_REPOSITORY}

RUN apt-get update && apt-get install -y \
    python3 \
    python3-pip \
    curl \
    git \
    apt-transport-https \
    ca-certificates \
    gnupg \
    lsb-release \
    tzdata

RUN curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add - && \
    echo "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | tee /etc/apt/sources.list.d/docker.list > /dev/null && \
    apt-get update && apt-get install -y docker-ce docker-ce-cli containerd.io

RUN curl -sSL -o /usr/local/bin/argocd https://github.com/argoproj/argo-cd/releases/latest/download/argocd-linux-amd64
RUN chmod +x /usr/local/bin/argocd

RUN mkdir /actions-runner && cd /actions-runner
WORKDIR /actions-runner
RUN curl -o actions-runner-linux-x64-2.299.1.tar.gz -L https://github.com/actions/runner/releases/download/v2.299.1/actions-runner-linux-x64-2.299.1.tar.gz
RUN tar xzf ./actions-runner-linux-x64-2.299.1.tar.gz

COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh

ENTRYPOINT ["/entrypoint.sh"]
