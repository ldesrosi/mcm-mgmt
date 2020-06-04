#!/bin/bash

echo 'Patching cluster role with correct access.'
echo 'This script is meant to be run against a managed cluster'
read -p "Is your kube config pointing to your managed cluster? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi
kubectl apply -f controller-role.yaml