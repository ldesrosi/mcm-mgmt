#!/bin/bash

if [[ $# -ne 1 ]]
then
  echo "Run: generateSecret.sh [image-registry-url]"
  exit 1
fi

echo 'Generating image pull secret from MCM Hub.'
echo 'This script is meant to be run against a hub cluster'
read -p "Is your kube config pointing to your hub cluster? " -n 1 -r
echo    # (optional) move to a new line
if [[ ! $REPLY =~ ^[Yy]$ ]]
then
    exit 1
fi

export IMAGE_REGISTRY=$1

kubectl create secret docker-registry mcm-dockercfg --docker-server=$IMAGE_REGISTRY --docker-username=$(oc whoami) --docker-password=$(oc whoami -t) -n default
kubectl get secret mcm-dockercfg -n default -o yaml > ./image-pull-secret.yaml
kubectl delete secret mcm-dockercfg -n default
