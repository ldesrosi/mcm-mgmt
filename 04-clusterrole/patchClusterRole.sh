#!/bin/bash

echo 'Patching cluster role with correct access.'
echo 'This script is meant to be run against a managed cluster'
read -p "Is your kube config pointing to your managed cluster? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
kubectl patch clusterrole controller-role --type=merge -p '{"rules": [{"apiGroups": [ "policies.ibm.com"], "resources": ["CertificatePolicies","certificatepolicies"], "verbs": ["get", "list", "watch", "create", "update",  "patch", "delete"]}]}'
kubectl patch clusterrole controller-role --type=merge -p '{"rules": [{"apiGroups": [ ""], "resources": ["namespaces"], "verbs": ["get", "list", "watch", "create", "update",  "patch", "delete"]}]}'
