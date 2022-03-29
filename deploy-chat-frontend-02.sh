#!/bin/bash -e

GIT_REPO=https://github.com/tonnyadhi/basic-redis-chat-demo-go
RAW_GIT_REPO=https://raw.githubusercontent.com/tonnyadhi/basic-redis-chat-demo-go/master
REDIS_ADDR=redis-02:6379
REDIS_PASSWORD=selainredis123

echo "Creating OpenShift Chat Frontend Service"
oc apply -f https://raw.githubusercontent.com/tonnyadhi/basic-redis-chat-demo-go/master/deploy_frontend_on_ocp_02.yaml 
echo ""

echo "Display Build Status"
oc logs -f buildconfig/chat-app-frontend-02
echo ""


echo "Waiting pod to be running"
sleep 10s
oc rollout restart deployment chat-app-frontend-02


echo "Fetching frontned URL"
export REACT_APP_CHAT_FRONTEND=$(oc get route chat-app-frontend-02 -o=jsonpath='{.spec.host}')
echo "your app can be accessed at:"
echo "https://"$REACT_APP_CHAT_FRONTEND
