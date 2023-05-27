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