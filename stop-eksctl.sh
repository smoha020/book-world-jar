#!/bin/bash

eksctl delete cluster \
    --config-file clusterConfig.yaml \
    --wait