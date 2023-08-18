#!/bin/bash


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

oidc_id=$(aws eks describe-cluster --name my-cluster --query "cluster.identity.oidc.issuer" --output text | cut -d '/' -f 5)

#b. check if it is in your account.

aws iam list-open-id-connect-providers | grep $oidc_id | cut -d "/" -f4

#c. Replace EXAMPLED539D4633E53DE1B71EXAMPLE with the output returned in the previous step


cat >load-balancer-role-trust-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::348815537453:oidc-provider/oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:aud": "sts.amazonaws.com",
                    "oidc.eks.region-code.amazonaws.com/id/EXAMPLED539D4633E53DE1B71EXAMPLE:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
                }
            }
        }
    ]
}
EOF


#d. create IAM Role for alb controller

aws iam create-role \
  --role-name AmazonEKSLoadBalancerControllerRole \
  --assume-role-policy-document file://"load-balancer-role-trust-policy.json"


#e. attach role to policy created earlier 

aws iam attach-role-policy \
  --policy-arn arn:aws:iam::348815537453:policy/AWSLoadBalancerControllerIAMPolicy \
  --role-name AmazonEKSLoadBalancerControllerRole

#f. create service account. 

cat >aws-load-balancer-controller-service-account.yaml <<EOF
apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/component: controller
    app.kubernetes.io/name: aws-load-balancer-controller
  name: aws-load-balancer-controller
  namespace: kube-system
  annotations:
    eks.amazonaws.com/role-arn: arn:aws:iam::348815537453:role/AmazonEKSLoadBalancerControllerRole
EOF

#g. create ervice account

kubectl apply -f aws-load-balancer-controller-service-account.yaml


##############################################

#4. Install ALB Ingress Controller
















