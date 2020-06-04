#!/bin/bash

echo 'Patching service accounts with image pull secrets.'
echo 'This script is meant to be run against a managed cluster'
read -p "Is your kube config pointing to your managed cluster? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

export IMAGE_REGISTRY=$1

kubectl create secret docker-registry mcm-dockercfg --docker-server=$IMAGE_REGISTRY --docker-username=$(oc whoami) --docker-password=$(oc whoami -t) -n mcm-cert-manager
kubectl create secret docker-registry mcm-dockercfg --docker-server=$IMAGE_REGISTRY --docker-username=$(oc whoami) --docker-password=$(oc whoami -t) -n kube-system
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "mcm-dockercfg"}]}' -n mcm-cert-manager
kubectl patch serviceaccount default -p '{"imagePullSecrets": [{"name": "mcm-dockercfg"}]}' -n kube-system