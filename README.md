[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/xxl-job-admin)](https://artifacthub.io/packages/search?repo=xxl-job-admin)
[![Release Charts](https://github.com/dellnoantechnp/helm-chart-xxl-job-admin/actions/workflows/workflow.yml/badge.svg)](https://github.com/dellnoantechnp/helm-chart-xxl-job-admin/actions/workflows/workflow.yml)
[![Release Downloads](https://img.shields.io/github/downloads/dellnoantechnp/helm-chart-xxl-job-admin/latest/total)](https://img.shields.io/github/downloads/dellnoantechnp/helm-chart-xxl-job-admin/latest/total)

<p align="center">
  <img width="200" height="200" src="https://www.xuxueli.com/doc/static/xxl-job/images/xxl-logo.jpg">
</p>

# Helm Chart repository
Github: [https://github.com/dellnoantechnp/helm-chart-xxl-job-admin](https://github.com/dellnoantechnp/helm-chart-xxl-job-admin)

## Usage:
### 1. Add helm repo
```shell
helm repo add xxl-job
helm repo update xxl-job
helm search repo xxl-job-admin
```

### 2. Pull chart
*tips: optional*
```shell
helm pull xxl-job/xxl-job-admin --untar
```

### 3. Install chart
```shell
helm install -n <namespace> my-xxl-job-admin xxl-job/xxl-job-admin \
--set database.db_address=127.0.0.1 \
--set database.user=db_usernmae \
--set database.password='abcde1234!@#' 
```

### 4. Custom `values.yaml` variables, and install from local
*custom multi variables from `values.yaml`*
```shell
helm install -n <namespace> my-xxl-job-admin xxl-job/xxl-job-admin .
```

### 5. Get current release values
```shell
helm list [-n <namespace>]
helm get values <release_name> [-n <namespace>] [-a|--all]
```


### 6. Uninstall release
```shell
helm list [-n <namespace>]
helm uninstall my-xxl-job-admin [-n <namespace>]
```