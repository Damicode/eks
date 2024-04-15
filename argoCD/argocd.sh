# Getting Star with ArgoCD

++++++++++++++++++++++++++++

# check the issuer or OIDC ID

#Retrieve your cluster's OIDC issuer ID
export cluster_name=damier-cluster
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

#print ID
echo $oidc_id
OIDC= 70AEABDE6BBB88717DFA0E778EB8AA35
ID= 958472341617
AWS_ACCOUNT_ID=$(aws sts get-caller-identity --query "Account" --output text)
OIDC_PROVIDER=$(aws eks describe-cluster --name management --query "cluster.identity.oidc.issuer" --output text | sed -e "s/^https:\/\///")
++++++++++++++++++++++++++++++

# Create a role fo ArgoCD to get aws access
aws iam create-role --role-name ArgoCD --assume-role-policy-document file://trust.json --description "IAM Role to be used by ArgoCD to gain AWS access"
# Assume role
aws iam put-role-policy --role-name ArgoCD --policy-name AssumeRole --policy-document file://policy.json
argocd-server
# Service accounts are
argocd-server
argocd-application-controller
argocd-dex-server
argocd-notifications-controller
argocd-redis
argocd-repo-server



#Install and SetUP

https://argo-cd.readthedocs.io/en/stable/getting_started/

# create namespace and download ArgoCD
kubectl create namespace argocd
kubectl apply -n argocd -f https://raw.githubusercontent.com/argoproj/argo-cd/stable/manifests/install.yaml
or
wget https://raw.githubusercontent.com/argoproj/argo-cd/v1.8.3/manifests/install.yaml
kubectl -n argocd apply -f install.yaml

kubectl create -f dev/application.yaml -n argocd
kubectl get pods -n argocd
kubectl get deployment -n argocd
# Access FROM UI

kubectl get svc -n argocd
kubectl port-forward svc/argocd-server -n argocd 8080:443

# User name
admin
# get the password
argocd admin initial-password -n argocd
# or
kubectl get secret argocd-initial-admin-secret - argocd -o yaml



echo "" | base64 -d


#Change the password using the command
argocd account update-password


kubectl logs -n argocd $(kubectl get pods -l app=workflow-controller -n argocd -o name)

aws eks get-token --cluster-name=damier-cluster

# Get ArgoCD password

ARGOCD_PASSWORD=$(kubectl get pods -n argocd -l app.kubernetes.io/name=argocd-server -o name | cut -d'/' -f 2)
echo $ARGOCD_PASSWORD

# Open up an extra terminal
kubectl port-forward svc/argocd-server -n argocd 8080:443


#Clean up
aws iam delete-role-policy --role-name ArgoCD --policy-name AssumeRole
aws iam delete-role --role-name ArgoCD



#https://www.modulo2.nl/blog/argocd-on-aws-with-multiple-clusters

