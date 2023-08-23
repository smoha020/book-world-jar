#!/bin/bash



#c. Replace EXAMPLED539D4633E53DE1B71EXAMPLE with the output returned in the previous step


cat >load-balancer-role-trust-policy.json <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Federated": "arn:aws:iam::348815537453:oidc-provider/oidc.eks.us-east-2.amazonaws.com/id/EE36BCB2CDB3AEC236F2804A0FC3645E"
            },
            "Action": "sts:AssumeRoleWithWebIdentity",
            "Condition": {
                "StringEquals": {
                    "oidc.eks.us-east-2.amazonaws.com/id/EE36BCB2CDB3AEC236F2804A0FC3645E:aud": "sts.amazonaws.com",
                    "oidc.eks.us-east-2.amazonaws.com/id/EE36BCB2CDB3AEC236F2804A0FC3645E:sub": "system:serviceaccount:kube-system:aws-load-balancer-controller"
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

#a. Install cert-manager
kubectl apply \
    --validate=false \
    -f https://github.com/jetstack/cert-manager/releases/download/v1.12.3/cert-manager.yaml



#b. Install the controller.

#i. Download the controller

#curl -Lo v2_5_4_full.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_full.yaml


#ii. Make edits
#Remove service account section (ONLY for version v2_5_4_full.yaml)

#sed -i.bak -e '596,604d' ./v2_5_4_full.yaml

#Replace your-cluster-name in the Deployment spec section of the file 

#sed -i.bak -e 's|your-cluster-name|springbootMysqlCluster|' ./v2_5_4_full.yaml

#Add the following to the - arg: section
#            - --aws-vpc-id=vpc-xxxxxxxx
#            - --aws-region=region-code
#
#

#iii. Apply the file

#kubectl apply -f v2_5_4_full.yaml


#iv. Download IngressClass and IngressClassParams manifests
curl -Lo v2_5_4_ingclass.yaml https://github.com/kubernetes-sigs/aws-load-balancer-controller/releases/download/v2.5.4/v2_5_4_ingclass.yaml

#v. Apply the manifests

#kubectl apply -f v2_5_4_ingclass.yaml



