#!/bin/bash

#CREATE SECRETS
kubectl apply -f /mysql-secrets.yaml

#APPLY MYSQL DEPLOYMENTS AND SERVICES
kubectl apply -f /mysql-manifests.yaml

#APPLY SPRING BOOT APP DEPLOYMENTS AND SERVICES
kubectl apply -f /app-manifests.yaml

#LAUNCH INGRESS CONTROLLER
kubectl apply -f /ingress-manifests.yaml

#APPLY INGRESS RULES
kubectl apply /ingress-rules.yaml