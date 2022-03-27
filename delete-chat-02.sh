#!/bin/bash -e

oc delete all --selector app=chat-app-backend-02
oc delete all --selector app=chat-app-frontend-02
kubectl delete cm chat-app-frontend-02
