#!/bin/bash

echo 'Patching service accounts with image pull secrets.'
echo 'This script is meant to be run against a MANAGED cluster'
read -p "Is your kube config pointing to your MANAGED cluster? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

kubectl apply -f ./image-pull-secret.yaml -n mcm-cert-manager
kubectl apply -f ./image-pull-secret.yaml  -n kube-system

kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "mcm-dockercfg"}]}' -n mcm-cert-manager
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "mcm-dockercfg"}]}' -n kube-system