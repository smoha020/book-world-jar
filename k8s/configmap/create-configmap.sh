#!/bin/bash


kubectl create namespace configmap-test

kubectl create configmap my-env-config --from-env-file=test.env --namespace=springboot-mysql

