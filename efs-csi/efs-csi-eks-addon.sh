#!/bin/bash


#FROM (https://docs.aws.amazon.com/eks/latest/userguide/managing-add-ons.html#creating-an-add-on)
#service account role is created after running the iam-efs-csi.sh and uses the EKS_EFS_CSI_Driver_Policy policy

eksctl create addon --cluster springbootMysqlCluster --name aws-efs-csi-driver --version latest \
    --service-account-role-arn arn:aws:iam::348815537453:role/eksctl-springbootMysqlCluster-addon-iamservi-Role1-O21RE4VRESOC --force
