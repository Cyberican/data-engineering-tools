#!/bin/sh

sudo kubectl create ns kubeflow
sudo kubectl apply -f https://github.com/wso2/k8s-api-operator/releases/download/v2.0.3/api-operator-configs.yaml
