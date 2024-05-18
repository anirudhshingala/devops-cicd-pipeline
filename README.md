# Devops-cicd-pipeline

## In this repo we have configured below points.

### 1. Created self hosted github action runners deployed on minikube cluster
a. Created Docker file. Configure github actions pipeline to build runner image and push image to docker hub
b. Created deployment for runner to deploy it on minikube cluster.
c. Files can be found in `github-runner` folder

### 2. Installed Argocd on minikube
a. Create argocd namespace
```sh
kubectl create ns argocd
```
b. Install argocd resources
```sh
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/v2.11.0/manifests/install.yaml
```
c. Login to argocd dashboard. We do port forward for argo server and that access dashboard on ```127.0.0.1:8080``` on localmachine
```sh
kubectl port-forward svc/argocd-server -n argocd 8080:443
```
d. Get login password using below command
Username: admin
Password: `kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 -d; echo`

### 3. Create a python app and create its helm chart
a. Create a Simple python app that runs on port 5000 and reads a file and expose its content on port 5000.
b. Create Dockerfile that can be used to create a image.
c. Create Github actions pipeline to build python app image and push it to Dockerhub
d. Create Helm chart that will be used in further process. Available in `python-app-helm` folder.

### 4. Automate Deployment of above Helm chart in minikube cluster using argocd on every push on this Repo

#### To achieve this we follow multiple steps.

#### a. Register Domain on cloudflare
##### Below steps are done to expose ArgoCD deployed on your local machine to internet securely using cloudflare. We will add this public endpoint as Webhook to trigger app sync in argocd via github.

>Alternative can be other tools like `ngrok`
>you can expose your local port on which argoCD is forwarded to.

a. If not already have, we will register a domain on cloudflare. 
b. Install `cloudflared` on local machine using this command 
```sh
brew install cloudflared
```
c. Once domain is registerd login to ```one.dash.cloudflare.com```
d. Create a Tunnel: 
    Steps:
    - Go to Networks > Tunnels > Create a tunnel
    - Tunnel type - cloudflared
    - Name your tunnel nad click on save
    - Go to Public Hostname page under you tunnel
    - Click on Add a Public Hostname
    - Add required domain and subdomain. eg: argocd.anirudhshingala.com
    - In service select http/https://127.0.0.1:8080 on which we have done port forwarding of argocd deployed on local minikube cluster in step 2-c
    - In overview section next to public hostname option, you will get cloudflared command that needs to be run on you machine to start tunnel as a service.
      eg: `sudo cloudflared service install <TOKEN>`
      once this is done your tunnel will be working
      you can check by opening argocd.anirudhshingala.com ie: domain you used in tunnel creation and you will see argocd dashboard which is running on you local machine

##### Add webhook to you required repo which has your helm chart that we will deploy on minikube
- Open the repo setting > Webhooks > Add webhooks
- Add Payload url as ```https://argocd.anirudhshingala.com/api/webhook``` ie: <argo-domain>/api/webhook. content type as applicatoin/json and trigger only on push event.

##### Add repository to argocd from where you need helm chart to be deployed
- Go to argo dashboard and Settings > Repositoris > Connect repo
- Choose connection method as Via HTTPS
- Under 'CONNECT REPO USING HTTPS' > 
    Type - git
    Repo URL - your repo url eg: https://github.com/anirudhshingala/devops-cicd-pipeline
    Username - <your github username>
    Password - <Personal Github token that has atleast read access to above repo>
If done correctly You will see connection status for repo as successful.

### 5. Create a Application in argocd namespace for our python app
a. Create a application-set.yaml as below. That has Your helm chart repo url, folder path for your chart on this repo, kubernetes cluster url etc
```sh
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: my-python-app
  namespace: argocd
spec:
  project: default
  source:
    repoURL: 'https://github.com/anirudhshingala/devops-cicd-pipeline'
    targetRevision: HEAD
    path: python-app-helm
    helm:
      valueFiles:
        - values.yaml
  destination:
    server: 'https://kubernetes.default.svc'
    namespace: default
  syncPolicy:
    automated:
      prune: true
      selfHeal: true
```
b. Apply this file in argocd namespace using below command
```kubectl apply -f application-set.yaml -n argocd```
c. You will now see an application on argo dashboard.

### Testing Entire process.
a. Make a code chage and commit to repo where you have configured webhook. 
b. This will trigger argocd application to pick helm chart and apply it on mentioned namespace.


## Voila You have now achiived man different things under CICD.
