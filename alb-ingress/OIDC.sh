#1. OIDC

#a. check if you have it

export cluster_name=springbootMysqlCluster
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)


#b. check if it is in your account.
aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4


#c. create the OIDC identity provider for this cluster
eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve


####################################

#2. Create IAM Policy

curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-load-balancer-controller/v2.5.4/docs/install/iam_policy.json

aws iam create-policy \
    --policy-name AWSLoadBalancerControllerIAMPolicy \
    --policy-document file://iam_policy.json


#3. Create Role and Service Account

#a. retrieve OIDC provider ID

oidc_id=$(aws eks describe-cluster --name springbootMysqlCluster --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

#b. check if it is in your account.

aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4
