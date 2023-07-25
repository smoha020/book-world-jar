#!/bin/bash

#To install the driver using images stored in the private Amazon ECR registry

#1. Download the manifest. Replace release-X.X with your desired branch. We recommend using the latest released version. For a list of active branches, see Branches.

kubectl kustomize \
    "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/ecr/?ref=release-1.X" > private-ecr-driver.yaml
#Note
#If you encounter an issue that you aren't able to resolve by adding IAM permissions, try the Manifest (public registry) steps instead.

#2. In the following command, replace region-code with the AWS Region that your cluster is in. Then run the modified command 
#to replace us-west-2 in the file with your AWS Region.

sed -i.bak -e 's|us-west-2|region-code|' private-ecr-driver.yaml

#3. Replace account in the following command with the account from Amazon container image registries for the AWS Region that 
#your cluster is in and then run the modified command to replace 602401143452 in the file.

sed -i.bak -e 's|602401143452|account|' private-ecr-driver.yaml

#4. If you already created a service account by following Create an IAM policy and role for Amazon EKS, then 
#edit the private-ecr-driver.yaml file. Remove the following lines that create a Kubernetes service account.

apiVersion: v1
kind: ServiceAccount
metadata:
  labels:
    app.kubernetes.io/name: aws-efs-csi-driver
  name: efs-csi-controller-sa
  namespace: kube-system
---

#Apply the manifest.

#kubectl apply -f private-ecr-driver.yaml
