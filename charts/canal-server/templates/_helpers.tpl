{{/*
Expand the name of the chart.
*/}}
{{- define "canal-server.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}


{{/* vim: set filetype=mustache: */}}
{{/*
Return the proper image name
{{ include "common.images.image" ( dict "imageRoot" .Values.path.to.the.image "global" $) }}
*/}}
{{- define "common.images.image" -}}
{{- $registryName := .imageRoot.registry -}}
{{- $repositoryName := .imageRoot.repository -}}
{{- $separator := ":" -}}
{{- $termination := .imageRoot.tag | toString -}}
{{- if .global }}
    {{- if .global.imageRegistry }}
     {{- $registryName = .global.imageRegistry -}}
    {{- end -}}
{{- end -}}
{{- if .imageRoot.digest }}
    {{- $separator = "@" -}}
    {{- $termination = .imageRoot.digest | toString -}}
{{- end -}}
{{- printf "%s/%s%s%s" $registryName $repositoryName $separator $termination -}}
{{- end -}}

{{/*
Return the proper canal-server; image name
*/}}
{{- define "canal.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}

{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "canal-server.fullname" -}}
{{- if .Values.fullnameOverride }}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- $name := default .Chart.Name .Values.nameOverride }}
{{- if contains $name .Release.Name }}
{{- .Release.Name | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Create a default fully qualified zookeeper name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "canal-server.zookeeper.fullname" -}}
{{- if .Values.zookeeper.fullnameOverride -}}
{{- .Values.zookeeper.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default "zookeeper" .Values.zookeeper.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "canal-server.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "canal-server.labels" -}}
helm.sh/chart: {{ include "canal-server.chart" . }}
{{ include "canal-server.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "canal-server.selectorLabels" -}}
app.kubernetes.io/name: {{ include "canal-server.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "canal-server.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "canal-server.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
canal-server-cm
*/}}
{{- define "canal.server.configmap.fullname" -}}
{{ include "canal-server.fullname" . }}-cm
{{- end }}

{{- /*
return canal.destinations string,
e.g: example,example2
*/ -}}
{{- define "canal.destinations" -}}
{{- $destinations := "" }}
{{- range .Values.InstanceConf.canal.instance }}
{{- $destinations = printf "%s,%s" $destinations .name }}
{{- end }}
{{- trimPrefix "," $destinations }}
{{- end }}

{{/*
return zkServers
e.g: server1:2181,server2:2181
*/}}
{{- define "zkServers" -}}
{{- if .Values.zookeeper.enabled }}
{{- if .Values.zookeeper.fullnameOverride -}}
{{- .Values.zookeeper.fullnameOverride | trunc 63 | trimSuffix "-" -}}:{{ .Values.zookeeper.service.port }}
{{- else -}}
{{- $name := default "zookeeper" .Values.zookeeper.nameOverride -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}:{{ .Values.zookeeper.service.port }}
{{- end }}
{{- else }}
{{- if .Values.externalZookeeper.servers }}
{{- join "," .Values.externalZookeeper.servers }}
{{- end }}
{{- end }}
{{- end }}

{{/*
return first zkServer address
e.g: zkServer1:2181
return: zkServer1
*/}}
{{- define "zkServer.address" }}
{{- $get_first := mustFirst (mustRegexSplit "," (include "zkServers" .) -1) }}
{{- $s1 := mustRegexSplit ":" $get_first -1 }}
{{- mustFirst $s1 }}
{{- end }}

{{/*
return first zkServer port
e.g: zkServer1:2181
return: 2181
*/}}
{{- define "zkServer.port" }}
{{- $get_first := mustFirst (mustRegexSplit "," (include "zkServers" .) -1) }}
{{- $s1 := mustRegexSplit ":" $get_first -1 }}
{{- mustLast $s1 }}
{{- end }}

{{/*
return canal-server canal.properties mount resouce string.
*/}}
{{- define "config.canal-properties" }}
- mountPath: /app/canal-server/conf/canal.properties
  subPath: canal.properties
  name: config
{{- end }}

{{/*
return canal-server instance instance.properties mount resouce string.
*/}}
{{- define "config.instances.instance-properties" }}
{{- range .Values.InstanceConf.canal.instance }}
- mountPath: /app/canal-server/conf/{{ .name }}/instance.properties
  subPath: {{ .name }}-instance.properties
  name: config
{{- end }}
{{- end }}

{{/*
canal-server instance HA detection config.
*/}}
{{- define "canal.instance.enable.detection" }}
## heartbeat instance HA config
canal.instance.detecting.enable=true
#canal.instance.detecting.sql = insert into retl.xdual values(1,now()) on duplicate key update x=now()
canal.instance.detecting.sql=select 1
canal.instance.detecting.interval.time=3
canal.instance.detecting.retry.threshold=3
canal.instance.detecting.heartbeatHaEnable=true
{{- end }}

{{/*
Return the proper image name (for the init container volume-permissions image)
*/}}
{{- define "canal-server.volumePermissions.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.volumePermissions.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Storage Class
*/}}
{{- define "canal-server.storageClass" -}}
{{/*
Helm 2.11 supports the assignment of a value to a variable defined in a different scope,
but Helm 2.9 and 2.10 does not support it, so we need to implement this if-else logic.
*/}}
{{- if .Values.global -}}
    {{- if .Values.global.storageClass -}}
        {{- if (eq "-" .Values.global.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.global.storageClass -}}
        {{- end -}}
    {{- else -}}
        {{- if .Values.persistence.storageClass -}}
              {{- if (eq "-" .Values.persistence.storageClass) -}}
                  {{- printf "storageClassName: \"\"" -}}
              {{- else }}
                  {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
              {{- end -}}
        {{- end -}}
    {{- end -}}
{{- else -}}
    {{- if .Values.persistence.storageClass -}}
        {{- if (eq "-" .Values.persistence.storageClass) -}}
            {{- printf "storageClassName: \"\"" -}}
        {{- else }}
            {{- printf "storageClassName: %s" .Values.persistence.storageClass -}}
        {{- end -}}
    {{- end -}}
{{- end -}}
{{- end -}}