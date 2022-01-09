# Redis - Go Lang - Socket.io - React :: Chat App Demo on OpenShift

## Introduction

Thanks to [Ajeet Raina](https://github.com/ajeetraina) for introducing me to the original repository which can be found [here](https://github.com/redis-developer/basic-redis-chat-demo-go) and [Roman Kurylchyk](https://github.com/beqdev) for initial contribution.

This fork contains the instruction for deploying Redis-Go-Chat-App on OpenShift

## Chat App Setup on OpenShift

### Get a Free OpenShift Cluster
- You can get your Free OpenShift Developer Sandbox by simply creating a free account [here](https://developers.redhat.com/developer-sandbox/get-started)
- Launch your Developer Sandbox and login to OpenShift Console
- Download the [OpenShift Client](https://docs.openshift.com/container-platform/4.7/cli_reference/openshift_cli/getting-started-cli.html) on your local machine
- Grab `OC CLI` login credentials from your OpenShift Console (shown below)

![image](https://user-images.githubusercontent.com/9701902/148698168-67a781e8-8473-47cf-83b6-0c0c3c2e6c3c.png)

![image](https://user-images.githubusercontent.com/9701902/148698185-9f4bbf50-5ebc-4140-8857-0910d4568584.png)


- Login to OC CLI

### Deploying Go Lang  Backend on OpenShift

```
# Set up Redis cluster address and credentials
# used during Deployment

export REDIS_ADDRESS=redis-xxxx.ap-south-1-1.ec2.cloud.redislabs.com:18689
export REDIS_PASSWORD=xxxx

# Deploy the Go Lang based backend API that uses Redis to store chat messages

# oc new-app will  use image steam to build container image from the source github repository
# and create Openshift Deployment configuration

oc new-app golang~https://github.com/ksingh7/basic-redis-chat-demo-go.git --name=chat-app-backend --env REDIS_ADDRESS=$REDIS_ADDRESS --env REDIS_PASSWORD=$REDIS_PASSWORD ; 

# This YAML file will create an OpenShift Service and OpenShift Route to make the endpoint available to the world
oc apply -f https://raw.githubusercontent.com/ksingh7/basic-redis-chat-demo-go/master/backend_ocp.yaml

# Building container image could take sometime, you can monitor the build process by using the following command
oc logs -f buildconfig/chat-app-backend

# once the build process is completed, you can check the status of pods using the following command
oc get po

# Once you see the backend pods running,  you can access the backend API using the following endpoint
export REACT_APP_CHAT_BACKEND=$(oc get route chat-app-backend -o=jsonpath='{.spec.host}')

# The health API endpoint confirms your Backend is working properly
curl https://$REACT_APP_CHAT_BACKEND/health

```

### Deploying React Frontend  on OpenShift

```
# Chat App React frontend needs to connect to backend API to function

# Grab backend API endpoint from the OpenShift Route
export REACT_APP_CHAT_BACKEND=$(oc get route chat-app-backend -o=jsonpath='{.spec.host}')

# Set environment variables in .env file on local machine

echo "REACT_APP_CHAT_BACKEND="$REACT_APP_CHAT_BACKEND >> .env
echo "REACT_APP_HTTP_PROXY=https://"$REACT_APP_CHAT_BACKEND >> .env

# Create a Openshift Config Map with the .env file
oc create configmap chat-app-frontend --from-file=.env 

# Use the following YAML to create container image from source git repository and create Openshift Deployment configuration, Service and Route
oc create -f https://raw.githubusercontent.com/ksingh7/basic-redis-chat-demo-go/master/frontend_ocp.yaml

# Montor the build process using the following command
oc logs -f buildconfig/chat-app-frontend

# Once the build process is completed, you can check the status of pods using the following command
oc get po

# Even after frontend container is running, allow a few minutes for React app to compile and start the server and be available to the world

export REACT_APP_CHAT_FRONTEND=$(oc get route chat-app-frontend -o=jsonpath='{.spec.host}')
echo "https://"$REACT_APP_CHAT_FRONTEND
```

### Summary
At this point you would be having the full fledge Redis - Go Lang - Socket.io - React :: Chat App Demo running on OpenShift
- Chat App login screen

![image](https://user-images.githubusercontent.com/9701902/148698222-67af7243-0269-4f32-a699-384ea5c11f65.png)

- Chat Screen

![image](https://user-images.githubusercontent.com/9701902/148698243-68fcddf8-1148-4fe2-9c23-b40b48b69ca4.png)

- OpenShift Resources

![image](https://user-images.githubusercontent.com/9701902/148698287-391751f5-3289-485d-807a-cc0b8f17c97d.png)


