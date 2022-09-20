#!/bin/bash

#CREATE NAMESPACE
kubectl apply -f k8s/namespace.yaml

#CREATE SECRETS
kubectl apply -f k8s/mysql-secrets.yaml 

#APPLY MYSQL DEPLOYMENTS AND SERVICES
kubectl apply -f k8s/mysql-manifests.yaml

#APPLY SPRING BOOT APP DEPLOYMENTS AND SERVICES
kubectl apply -f k8s/app-manifests.yaml

#LAUNCH INGRESS CONTROLLER
kubectl apply -f k8s/ingress-manifests.yaml

#APPLY INGRESS RULES
kubectl apply k8s/ingress-rules.yaml