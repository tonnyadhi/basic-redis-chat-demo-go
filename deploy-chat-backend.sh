#!/bin/bash -e

GIT_REPO=https://github.com/tonnyadhi/basic-redis-chat-demo-go
RAW_GIT_REPO=https://raw.githubusercontent.com/tonnyadhi/basic-redis-chat-demo-go/master
REDIS_ADDR=redis:6379
REDIS_PASSWORD=selainredis123

echo "Creating OpenShift Chat Backend Service"
oc new-app golang~$GIT_REPO.git --name=chat-app-backend --env REDIS_ADDRESS=$REDIS_ADDR --env REDIS_PASSWORD=$REDIS_PASSWORD ;
echo ""
             
echo "Apply k8s deployment and service"
oc apply -f https://raw.githubusercontent.com/tonnyadhi/basic-redis-chat-demo-go/master/deploy_backend_on_ocp.yaml
echo ""

echo "Display Build Status"
oc logs -f buildconfig/chat-app-backend
echo ""

echo "Waiting pod to be running"
sleep 20s

echo "Check Backend Health"
export REACT_APP_CHAT_BACKEND=$(oc get route chat-app-backend -o=jsonpath='{.spec.host}')
curl https://$REACT_APP_CHAT_BACKEND/health
echo ""


echo "Preparing env for frontend"
echo "REACT_APP_CHAT_BACKEND="$REACT_APP_CHAT_BACKEND >> .env
echo "REACT_APP_HTTP_PROXY=https://"$REACT_APP_CHAT_BACKEND >> .env
oc create configmap chat-app-frontend --from-file=.env
echo ""
