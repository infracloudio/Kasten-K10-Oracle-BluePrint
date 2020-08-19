# ORACLE18c

[ORACLE](https://www.oracle.com/database/technologies/) Database is a multi-model database management system produced and marketed by Oracle Corporation. It is a database commonly used for running online transaction processing, data warehousing and mixed database workloads.

## Introduction

This Oracle 18c database deployment on [Kubernetes](http://kubernetes.io) cluster with persistent storage.

## Create a docker image by cloning the Oracle maintained Docker files from [GitHub](https://github.com/oracle/docker-images).

```bash

#Clone the code from repository
$ git clone https://github.com/oracle/docker-images.git

#Nevigate to the docker file directory
$ cd docker-images/OracleDatabase/SingleInstance/dockerfiles

#Build the image
$ ./buildDockerImage.sh -v 18.3.0 -ee

#List the docker images
$ docker images

```

Please move this docker image to your K8s node

```bash

#Save docker image as tar
$ docker save oracle/database > oracle18ee.tar

#Copy or move this tar file to your node using ssh, scp or available techniques.

#Load the tar file and list the images
$ docker laod < oracle18ee.tar
$ docker images

```

## Creating Oracle 18c deployment

```bash
# Create a namespace oracle18ee
$ kubectl create ns oracle18ee

# Create a configmap with the required properties
$ kubectl create configmap oradb --from-env-file=oracle18ee/oracle.properties -n oracle18ee

# Create a Persistance Volume Claim
$ kubectl -n oracle18ee apply -f oracle18e/oracledb-pvc.yaml

# Create a deployment
$ kubectl -n oracle18ee apply -f oracle18ee/oracle18ee-deployment.yaml

```

The command deploys a Oracle instance in the `oracle18ee` namespace.

By default a password is reffered from the configmap `oradb`. Also you can get the password from running oracle pod `kubectl -n oracle18ee logs [YOUR_POD_NAME] -f`

> **Tip**: List all releases using `kubectl -n oracle18ee get all` .

## Connect to Database from inside the pod

```bash

# Exec into pod and run following command to get OracleDB is running
$ kubectl -n oracle18ee exec -it [YOUR_POD_NAME] -- bash

# And now you can connect to oracledb
$ sqlplus / as sysdba

```
## Connect to Database from outside the pod

```bash

# Get service url of running deployment
$ kubectl -n oracle18ee get service

# And now you can connect to oracledb
$ sqlplus sys/{ORACLE_PASSWD}@{SERVICE_URL}:{PORT_NO}/{DB_NAME} as sysdba

```

## Cleanup

### Uninstalling the deployment

To uninstall/delete the `oracle` deployment:

```bash
# Delete the deployment
$ kubectl -n oracle18ee delete -f oracle18ee/oracle18ee-deployment.yaml

# Delete the Persistance Volume claim
$ kubectl -n oracle18ee delete -f oracle18ee/oracledb-pvc.yaml

# Delete the namespace oracle18ee
$ kubectl delete ns oracle18ee
```

The command removes all the Kubernetes components associated with the chart and deletes the release.

