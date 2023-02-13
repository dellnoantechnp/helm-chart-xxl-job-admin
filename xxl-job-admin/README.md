## Introduction

This chart bootstraps a [xxl-job-admin](https://github.com/xuxueli/xxl-job/) replication  cluster deployment on a [Kubernetes](https://kubernetes.io/) cluster using the [Helm](https://helm.sh/) package manager.

Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- MySQL 5.6+

## Usage

[Helm](https://helm.sh) must be installed to use the charts.  Please refer to
Helm's [documentation](https://helm.sh/docs) to get started.

Once Helm has been set up correctly, add the repo as follows:

```shell
helm repo add <repo_name> https://dellnoantechnp.github.io/charts
helm repo list
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
xxl-job-admin` to see the charts.

To quick install the xxl-job-admin chart:

```shell
helm install my-xxl-job-admin <repo_name>/xxl-job-admin
```

To install the xxl-job-admin with custom values:
```shell
helm install -n <namespace> my-xxl-job-admin <repo_name>/xxl-job-admin \
  --set database.db_address=127.0.0.1 \
  --set database.user=db_usernmae \
  --set database.password=abcde1234!@# 
```

Open your browser open [http://xxl-job-admin-svc:8080/xxl-job-admin](http://xxl-job-admin-svc:8080/xxl-job-admin)
```log
# Default username 
admin
# Default password
123456
```

To uninstall the chart:

```shell
helm list 
helm uninstall my-xxl-job-admin
```


## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing).
To see all configurable options with detailed comments, visit the chart's [values.yaml](values.yaml), or run these configuration commands:

```console
# Helm 3
$ helm show values <repo_name>/xxl-job-admin
```

## Configure database 
Set connection detail of [MySQL](https://www.mysql.com) for xxl-job-admin

```yaml
## configure the database detail
database:
  db_address: x.x.x.x
  db_port: 3306
  user: ****
  password: ****
  db: xxl_job
  serverTimezone: UTC
```

## Init database

Download the `tables_xxl_job.sql` from https://github.com/xuxueli/xxl-job/blob/master/doc/db/tables_xxl_job.sql to init database