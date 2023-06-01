<!--- app-name: Alibaba Canal-Server -->

# Canal-Server
Version: *1.1.6*

[Canal](https://github.com/alibaba/canal) is capable of parsing MySQL binlog and subscribe to the data change, while Canal Client can be implemented to broadcast the change to anywhere,

e.g. other database and Apache Kafka.


## Prerequisites

- Kubernetes 1.19+
- Helm 3.2.0+
- MySQL 5.6+

## TL;DR

```console
REPO_NAME=xxl-job
helm repo add ${REPO_NAME} https://dellnoantechnp.github.io/helm-chart-xxl-job-admin/
helm install my-release ${REPO_NAME}/canal-server
```

If you had already added this repo earlier, run `helm repo update` to retrieve
the latest versions of the packages.  You can then run `helm search repo
canal-server` to see the charts.

To quick install the canal-server chart:

```shell
helm install my-canal-server ${REPO_NAME}/canal-server
```

To install the canal-server with custom values:
```shell
cat > custom.yaml <<EOF
InstanceConf:
  canal:
    instance:
      - name: business1
        mysql:
          slaveId:
            autoGenerate: true
            number: 12345
        gtidon: true
        master:
          address: 192.168.11.30
          port: 3306
          ## @param journalName type string, it's mysql-binlog name, default none.
          ##
          journalName: ""
          ## @param position type int, it's binlog position, default none.
          ##
          position: ""
          ## @param timestamp type int of microseconds-timestamp, it's mysql binlog timestamp, default none.
          ## Example SQL: select FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000) as NOW_ms;
          ##
          timestamp: ""
          ## @param gtid type is int, it's position of master gtid, default none.
          ##
          gtid: ""
        standby:
          ## @param enable standby mysql slave.
          ## if true, it will be auto enable instance.detection check.
          ## if true, it will be auto enable instance.detection.heartbeatHaEnable.
          ##
          enabled: true
          address: 192.168.11.31
          port: 3306
          ## @param journalName type string, it's mysql-binlog name, default none.
          ##
          journalName: ""
          ## @param position type int, it's binlog position, default none.
          ##
          position: ""
          ## @param timestamp type int of microseconds-timestamp, it's mysql binlog timestamp, default none.
          ## Example SQL: select FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000) as NOW_ms;
          ##
          timestamp: ""
          ## @param gtid type is int, it's position of master gtid, default none.
          ##
          gtid: ""
        dbUsername: canal
        dbPassword: "canal_passwd123"
        filter:
          regex: ".*\\..*"
          black:
            regex: "mysql\\.slave_.*"
      - name: business2
        gtidon: true
        mysql:
          slaveId:
            autoGenerate: true
            number: 12300
        master:
          address: 192.168.22.30
          port: 3306
          ## @param journalName type string, it's mysql-binlog name, default none.
          ##
          journalName: ""
          ## @param position type int, it's binlog position, default none.
          ##
          position: ""
          ## @param timestamp type int of microseconds-timestamp, it's mysql binlog timestamp, default none.
          ## Example SQL: select FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000) as NOW_ms;
          ##
          timestamp: ""
          ## @param gtid type is int, it's position of master gtid, default none.
          ##
          gtid: ""
        standby:
          ## @param enable standby mysql slave.
          ## if true, it will be auto enable instance.detection check.
          ## if true, it will be auto enable instance.detection.heartbeatHaEnable.
          ##
          enabled: true
          address: 192.168.22.31
          port: 3306
          ## @param journalName type string, it's mysql-binlog name, default none.
          ##
          journalName: ""
          ## @param position type int, it's binlog position, default none.
          ##
          position: ""
          ## @param timestamp type int of microseconds-timestamp, it's mysql binlog timestamp, default none.
          ## Example SQL: select FLOOR(UNIX_TIMESTAMP(NOW(3)) * 1000) as NOW_ms;
          ##
          timestamp: ""
          ## @param gtid type is int, it's position of master gtid, default none.
          ##
          gtid: ""
        dbUsername: canal
        dbPassword: canal_passwd456
        filter:
          regex: "business2\\.*"
          black:
            regex: "mysql\\.slave_.*"
TsdbDBConf:
  enabled: true
  canal_tsdb_mysql_address: 172.16.100.50
  canal_tsdb_mysql_port: 3306
  canal_tsdb_db_name: canal_tsdb
  canal_tsdb_db_user: canal
  canal_tsdb_db_password: canal_tsdb_pass
EOF

## install chart
helm install -n <namespace> my-canal-server ${REPO_NAME}/canal-server -f custom.yaml
```

To uninstall the chart:

```shell
helm list 
helm uninstall my-canal-server
```


## Configuration

See [Customizing the Chart Before Installing](https://helm.sh/docs/intro/using_helm/#customizing-the-chart-before-installing).
To see all configurable options with detailed comments, visit the chart's [values.yaml](values.yaml), or run these configuration commands:

```console
# Helm 3
$ helm inspect values <repo_name>/canal-server
```
