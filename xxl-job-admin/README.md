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

    helm repo add <alias> https://dellnoantechnp.github.io/charts

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
xxl-job-admin` to see the charts.

To install the xxl-job-admin chart:

    helm install my-xxl-job-admin <alias>/xxl-job-admin

To uninstall the chart:

    helm uninstall my-xxl-job-admin


## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing).
To see all configurable options with detailed comments, visit the chart's [values.yaml](values.yaml), or run these configuration commands:

```console
# Helm 3
$ helm show values <alias>/xxl-job-admin
```

## Configure database 
Set connection detail of [MySQL](https://www.mysql.com) for xxl-job-admin

    ## configure the database detail
    database:
      url: jdbc://***
      user: ****
      password: ****
      db: xxl_job
      serverTimezone: UTC

## Init database

Download the `tables_xxl_job.sql` from https://github.com/xuxueli/xxl-job/blob/master/doc/db/tables_xxl_job.sql to init database