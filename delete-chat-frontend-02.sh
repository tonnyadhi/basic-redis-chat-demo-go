#!/bin/bash -e

oc delete all --selector app=chat-app-frontend-02
kubectl delete cm chat-app-frontend-02
