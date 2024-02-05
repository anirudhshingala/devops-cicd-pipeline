# devops-cicd-pipeline
This repo will have code for cicd of application from github to k8 with monitoring

## Prerequisite 
1. Kubernetes cluster created using kubeadm on EC2.

## Process to automate
1. Github actions pipeline to build application and docker image.
2. Use argocd(deployed remotly) to deploy application automatically on kubernetes(deployed on AWS ec2).
3. Add automated monitoring and alerting using prometheus and alertmanager for all application deployed through this pipeline.
4. Create Grafana dashboard to automatically capture metrics and sort and filter it according to applications.
5. Create yaml and replace github action with some other tool to build application and docker image and standardize this yaml to accespt values that will be used by helm charts to deploy application.
    
