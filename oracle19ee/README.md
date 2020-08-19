# ORACLE19c

[ORACLE](https://www.oracle.com/database/technologies/) Database is a multi-model database management system produced and marketed by Oracle Corporation. It is a database commonly used for running online transaction processing, data warehousing and mixed database workloads.

## Introduction

This Oracle 19c database deployment on [Kubernetes](http://kubernetes.io) cluster with persistent storage.

## Creating Oracle 19c deployment

```bash
# Create a namespace oracle19ee
$ kubectl create ns oracle19ee

# Create a configmap with the required properties
$ kubectl create configmap oradb --from-env-file=oracle19ee/oracle.properties -n oracle19ee

# Create a Persistance Volume Claim
$ kubectl -n oracle19ee apply -f oracle19ee/oracledb-pvc.yaml

# Create a deployment
$ kubectl -n oracle19ee apply -f oracle19ee/oracle19ee-deployment.yaml

```

The command deploys a Oracle instance in the `oracle19ee` namespace.

By default a password is reffered from the configmap `oradb`. Also you can get the password from running oracle pod `kubectl -n oracle19ee logs [YOUR_POD_NAME] -f`

> **Tip**: List all releases using `kubectl -n oracle19ee get all` .

## Cleanup

### Uninstalling the deployment

To uninstall/delete the `oracle` deployment:

```bash
# Delete the deployment
$ kubectl -n oracle19ee delete -f oracle19ee/oracle19ee-deployment.yaml

# Delete the Persistance Volume claim
$ kubectl -n oracle19ee delete -f oracle19ee/oracledb-pvc.yaml

# Delete the namespace oracle19ee
$ kubectl delete ns oracle19ee
```

The command removes all the Kubernetes components associated with the chart and deletes the release.
