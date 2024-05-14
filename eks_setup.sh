#To install the AWS CLI
curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install

#check Version
aws --version


#Check if Kubectl is installed
kubectl version --client

#Instaling eksctl
curl --silent --location "https://github.com/weaveworks/eksctl/releases/latest/download/eksctl_$(uname -s)_amd64.tar.gz" | tar xz -C /tmp
#Move the extracted binary to /usr/local/bin
sudo mv /tmp/eksctl /usr/local/bin
#check version
eksctl version

#tar the file

#tar -xvf eksctl_Linux_arm64.tar.gz -C /tmp && rm  -rf eksctl_Linux_arm64.tar.gz
#sudo mv /tmp/eksctl /usr/local/bin

# Check Permissions policies (9)
AdministratorAccess
AmazonDynamoDBFullAccess	
AmazonEC2FullAccess	
AmazonEKSClusterPolicy	
AmazonEKSFargatePodExecutionRolePolicy	
AmazonS3FullAccess	
AmazonVPCFullAccess	
AWSCloudFormationFullAccess	
IAMUserChangePassword

------------------- CLUSTER ------------------------------

#To check the current user on AWS
aws sts get-caller-identity

#Configure aws
aws configure

# chek at the  CloudFormation if stack of the cluster is not already created
eksctl-<MY-CLUSTER-NAME>-cluster
eksctl-damier-cluster-cluster

#create Cluster
eksctl create cluster --name damier-cluster --region region-code
eksctl create cluster --name damier-cluster --region us-east-1 --fargate

eksctl create cluster --name damier-cluster \
    --region us-east-1 --fargate

#Delete Cluster
eksctl delete cluster --name damier-cluster --region us-east-1


#Create Fargate Profile

eksctl create fargateprofile \
    --cluster damier-cluster \
    --region us-east-1 \
    --name alb-damier-app \
    --namespace frontend-app



------------------- CLUSTER ------------------------------

#update the configuration

aws eks update-kubeconfig --region us-east-1 --name damier-cluster

#file at config location
~/.kube

#view the AWS CloudFormation stack
eksctl-damier-cluster-cluster




=================================


#Download IAM policy
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

#Create IAM Policy
aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json

                  AWSLoadBalancerControllerIAMPolicy  
----------------------------------------
#Retrieve your cluster's OIDC issuer ID
export cluster_name=damier-cluster
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

#print ID
echo $oidc_id


#check cluster's issuer ID is already in your account
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4

#Create an IAM OIDC identity provider
eksctl utils associate-iam-oidc-provider \
    --cluster $cluster_name --approve

----------------------------------------
#Create IAM Role

eksctl create iamserviceaccount --cluster=damier-cluster \
  --namespace=frontend-app \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::958472341617:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve 
  #--override-existing-serviceaccounts 
  

aws-load-balancer-controller

eksctl create iamserviceaccount \
  --cluster=<your-cluster-name> \
  --namespace=kube-system \
  --name=aws-load-balancer-controller \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --attach-policy-arn=arn:aws:iam::<your-aws-account-id>:policy/AWSLoadBalancerControllerIAMPolicy \
  --approve


==================================

#View your cluster nodes
kubectl get nodes -o wide


#Delete Cluster
eksctl delete cluster --name damier-cluster --region region-code


#Create the Amazon EKS cluster IAM role
aws iam create-role --role-name myAmazonEKSClusterRole --assume-role-policy-document file://"cluster-trust-policy.json"

#Attach the Amazon EKS managed policy 
aws iam attach-role-policy --policy-arn arn:aws:iam::aws:policy/AmazonEKSClusterPolicy --role-name myAmazonEKSClusterRole



 #   eksctl utils associate-iam-oidc-provider --region=us-east-1 --cluster=damier-cluster

#Add encryption to your cluster 
eksctl utils enable-secrets-encryption \
    --cluster damier-cluster \
    --key-arn arn:aws:kms:region-code:account:key/key


++++++++++++++++++++Deploy-ALB-Controller+++++++++++++++++++++++++++++++

#Add helm repo
helm repo add eks https://aws.github.io/eks-charts

#Update the repo
helm repo update eks

#Install

helm install aws-load-balancer-controller eks/aws-load-balancer-controller -n frontend-app \
  --set clusterName=damier-cluster \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=us-east-1 \
  --set vpcId=vpc-00653a9d68e234705

helm install aws-load-balancer-controller eks/aws-load-balancer-controller \            
  -n kube-system \
  --set clusterName=<your-cluster-name> \
  --set serviceAccount.create=false \
  --set serviceAccount.name=aws-load-balancer-controller \
  --set region=<region> \
  --set vpcId=<your-vpc-id>


#Verify that the deployments are running.
kubectl get deployment -n frontend-app aws-load-balancer-controller  

++++++++++++++++++++++++++++++++++++++++++++++++++++

helm delete aws-load-balancer-controller  -n frontend-app
helm delete aws-load-balancer-controller -n kube-system


aws s3api delete-bucket --bucket my-bucket --region us-east-1

