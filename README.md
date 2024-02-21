[![Artifact Hub](https://img.shields.io/endpoint?url=https://artifacthub.io/badge/repository/xxl-job-admin)](https://artifacthub.io/packages/search?repo=xxl-job-admin)
[![Release Charts](https://github.com/dellnoantechnp/helm-chart-xxl-job-admin/actions/workflows/workflow.yml/badge.svg)](https://github.com/dellnoantechnp/helm-chart-xxl-job-admin/actions/workflows/workflow.yml)
[![Release Downloads](https://img.shields.io/github/downloads/dellnoantechnp/helm-chart-xxl-job-admin/latest/total)](https://img.shields.io/github/downloads/dellnoantechnp/helm-chart-xxl-job-admin/latest/total)
[![Release Version](https://img.shields.io/github/v/release/dellnoantechnp/helm-chart-xxl-job-admin?label=Chart-release)](https://img.shields.io/github/v/release/dellnoantechnp/helm-chart-xxl-job-admin?label=Chart-release)

<p align="center">
  <img width="200" alt="XXL-JOB" height="200" src="https://www.xuxueli.com/doc/static/xxl-job/images/xxl-logo.jpg">
  <img width="200" alt="PrometheusAlert" height="200" src="https://feiyu563.github.io/static/img/prometheus-ico.png">
  <img width="150" alt="RocketMQ" height="200" src="https://rocketmq.apache.org/zh/img/Apache_RocketMQ_logo.svg.png">
</p>
<p align="center">
  <img width="250" alt="kafka" height="130" src="https://kafka.apache.org/logos/kafka_logo--simple.png">
  <img width="250" alt="canal-server" height="150" src="https://raw.githubusercontent.com/dellnoantechnp/helm-chart-xxl-job-admin/main/assets/stacks/canal/img/canal-512x512.png">
</p>

# This helm chart repository include charts:
- [x] xxl-job-admin web
- [x] rocketmq
- [x] prometheusAlert-*v4.9*
  - Project: [https://github.com/feiyu563/PrometheusAlert](https://github.com/feiyu563/PrometheusAlert)
  - About: A Alert-Center for Prometheus Grafana and Graylog, alert message deliver to Wechat/Feishu/Lark/email/DingTalk/workWechat/webhook/telegram ...
- [x] kafka-*2.8.1*
- [x] zookeeper-*3.7.0*
- [x] canal-server-*1.1.6*  
  - Project: [https://github.com/alibaba/canal](https://github.com/alibaba/canal)
  - About: Subscription MySQL binlog to mysql/kafka/es/hbase/rocketMQ. 
- [x] Kadalu-Operator-*v1.1.7*: 
  - Project: [https://github.com/kadalu/kadalu](https://github.com/kadalu/kadalu)
  - About: A lightweight Persistent storage solution for Kubernetes using GlusterFS in background. 



# Helm Charts repository
Helm Charts repository: [https://dellnoantechnp.github.io/helm-chart-xxl-job-admin/](https://dellnoantechnp.github.io/helm-chart-xxl-job-admin/)

# How to usage:
```shell
helm repo add dellnoantechnp https://dellnoantechnp.github.io/helm-chart-xxl-job-admin
helm repo update
helm search repo dellnoantechnp
```