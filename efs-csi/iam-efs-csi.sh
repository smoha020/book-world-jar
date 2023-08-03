#!/bin/bash


###############CHECK FOR IODC########################

#1. Determine whether you have an existing IAM OIDC provider for your cluster.
#Retrieve your cluster's OIDC provider ID and store it in a variable. Replace my-cluster with your own value.

export cluster_name=springbootMysqlCluster
oidc_id=$(aws eks describe-cluster --name $cluster_name --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

#2. Determine whether an IAM OIDC provider with your cluster's ID is already in your account.

aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4


#If output is returned, then you already have an IAM OIDC provider for your cluster and you can 
#skip the next step. If no output is returned, then you must create an IAM OIDC provider for your cluster.

#3.Create an IAM OIDC identity provider for your cluster with the following command.

eksctl utils associate-iam-oidc-provider --cluster $cluster_name --approve




####################IAM POLICY######################

#1. Create an IAM policy that allows the CSI driver's service account to make calls to AWS APIs on your behalf.

#i. Download the IAM policy document.
curl -O https://raw.githubusercontent.com/kubernetes-sigs/aws-efs-csi-driver/master/docs/iam-policy-example.json

#ii. Create the policy. You can change EKS_EFS_CSI_Driver_Policy to a different name, but if you do, make sure to change it in later steps too.

aws iam create-policy \
    --policy-name EKS_EFS_CSI_Driver_Policy \
    --policy-document file://iam-policy-example.json

#2. Create an IAM role and attach the IAM policy to it. Annotate the Kubernetes service account with the 
#IAM role ARN and the IAM role with the Kubernetes service account name. You can create the role using eksctl or the AWS CLI.

#[EKSCTL]

#Run the following command to create the IAM role and Kubernetes service account. It also attaches the policy to the role, annotates the 
#Kubernetes service account with the IAM role ARN, and adds the Kubernetes service account name to the trust policy for the IAM role. 
#Replace my-cluster with your cluster name and 111122223333 with your account ID. Replace region-code with the AWS Region that your 
#cluster is in. If your cluster is in the AWS GovCloud (US-East) or AWS GovCloud (US-West) AWS Regions, then replace arn:aws: with arn:aws-us-gov:.

eksctl create iamserviceaccount \
    --cluster springbootMysqlCluster \
    --namespace kube-system \
    --name efs-csi-controller-sa \
    --attach-policy-arn arn:aws:iam::348815537453:policy/EKS_EFS_CSI_Driver_Policy \
    --approve \
    --region us-east-2 
