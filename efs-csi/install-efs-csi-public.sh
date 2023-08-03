#!/bin/bash

#1. Install from public registry

kubectl kustomize \
    "github.com/kubernetes-sigs/aws-efs-csi-driver/deploy/kubernetes/overlays/stable/?ref=release-1.5" > public-ecr-driver.yaml



#2. If you already created a service account by following Create an IAM policy and role, then edit the 
#public-ecr-driver.yaml file. Remove the following lines that create a Kubernetes service account.

#apiVersion: v1
#kind: ServiceAccount
#metadata:
#  labels:
#    app.kubernetes.io/name: aws-efs-csi-driver
#  name: efs-csi-controller-sa
#  namespace: kube-system
#---


#3. apply the file

#kubectl apply -f public-ecr-driver.yaml
