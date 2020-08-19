# ORACLE12c

[ORACLE](https://www.oracle.com/database/technologies/) Database is a multi-model database management system produced and marketed by Oracle Corporation. It is a database commonly used for running online transaction processing, data warehousing and mixed database workloads.

## Introduction

This Oracle 12c database deployment on [Kubernetes](http://kubernetes.io) cluster with persistent storage.

## Creating Oracle 12c deployment

```bash
#Create a namespace oracle12c
$ kubectl create ns oracle12c

#Create Docker login secret
$ kubectl create secret docker-registry oracle \
  --docker-server=docker.io \
  --docker-username={USER_NAME} \
  --docker-password={PASSWORD} \
  --docker-email={USER_EMAIL} \
  -n oracle12c

# Create a configmap with the required properties
$ kubectl create configmap oradb --from-env-file=oracle12c/oracle.properties -n oracle12c

# Create a Persistance Volume Claim
$ kubectl -n oracle12c apply -f oracle12c/oracledb-pvc.yaml

# Create a deployment
$ kubectl -n oracle12c apply -f oracle12c/oracle12c-deployment.yaml

```

The command deploys a Oracle instance in the `oracle12c` namespace.

By default a password is reffered from the configmap `oradb`. Also you can get the password from running oracle pod `kubectl -n oracle12c logs [YOUR_POD_NAME] -f`

> **Tip**: List all releases using `kubectl -n oracle12c get all` .

## Connect to Database from inside the pod

```bash

# Exec into pod and run following command to get OracleDB is running
$ kubectl -n oracle12c exec -it [YOUR_POD_NAME] -- bash

# And now you can connect to oracledb
$ sqlplus / as sysdba

```
## Connect to Database from outside the pod

```bash

# Get service url of running deployment
$ kubectl -n oracle12c get service

# And now you can connect to oracledb
$ sqlplus sys/{ORACLE_PASSWD}@{SERVICE_URL}:{PORT_NO}/{DB_SID}.{DB_DOMAIN} as sysdba
$ sqlplus sys/Kube#2020@{SERVICE_URL}:1521/PSTG.localdomain as sysdba

```

## Cleanup

### Uninstalling the deployment

To uninstall/delete the `oracle` deployment:

```bash
# Delete the deployment
$ kubectl -n oracle12c delete -f oracle12c/oracle12c-deployment.yaml

# Delete the Persistance Volume claim
$ kubectl -n oracle12c delete -f oracle12c/oracledb-pvc.yaml

# Delete the namespace oracle12c
$ kubectl delete ns oracle12c
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
