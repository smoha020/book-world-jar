#!/bin/bash

eksctl delete cluster \
    --config-file cluster-1.18.yaml \
    --wait