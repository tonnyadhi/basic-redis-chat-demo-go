#!/bin/bash -e

oc delete all --selector app=chat-app-frontend
kubectl delete cm chat-app-frontend
