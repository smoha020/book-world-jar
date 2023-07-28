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

#1.This is the approach from the AWS docs (https://docs.aws.amazon.com/eks/latest/userguide/csi-iam-role.html). 

#2. Create an IAM role and attach the required AWS managed policy with the following command. Replace my-cluster 
#with the name of your cluster. The command deploys an AWS CloudFormation stack that creates an IAM role and 
#attaches the IAM policy to it. If your cluster is in the AWS GovCloud (US-East) or AWS GovCloud (US-West) AWS Regions, 
#then replace arn:aws: with arn:aws-us-gov:.

#Keep in mind that this policy is managed by AWS so unlike for the iam-efs-csi.sh, you don't need to create a policy.

eksctl create iamserviceaccount \
    --name ebs-csi-controller-sa \
    --namespace kube-system \
    --cluster springbootMysqlCluster \
    --role-name AmazonEKS_EBS_CSI_DriverRole \
    --role-only \
    --attach-policy-arn arn:aws:iam::aws:policy/service-role/AmazonEBSCSIDriverPolicy \
    --approve

#3. To add the Amazon EBS CSI add-on using eksctl

eksctl create addon --name aws-ebs-csi-driver --cluster springbootMysqlCluster --service-account-role-arn arn:aws:iam::348815537453:role/AmazonEKS_EBS_CSI_DriverRole --force

#4. to delete it
#eksctl delete addon --cluster springbootMysqlCluster --name aws-ebs-csi-driver 
