{{/*
Expand the name of the chart.
*/}}
{{- define "cloudeye-exporter.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "cloudeye-exporter.fullname" -}}
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
{{- define "cloudeye-exporter.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{ define "cloudeye-exporter.labels" -}}
helm.sh/chart: {{ include "cloudeye-exporter.chart" . }}
{{ include "cloudeye-exporter.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "cloudeye-exporter.selectorLabels" -}}
app.kubernetes.io/name: {{ include "cloudeye-exporter.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "cloudeye-exporter.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "cloudeye-exporter.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the proper cloudeye-exporter image name
*/}}
{{- define "cloudeye-exporter.image" -}}
{{ include "common.images.image" (dict "imageRoot" .Values.image "global" .Values.global) }}
{{- end -}}

{{/*
Return the proper Docker Image Registry Secret Names
*/}}
{{- define "cloudeye-exporter.imagePullSecrets" -}}
{{- include "common.images.renderPullSecrets" (dict "images" (list .Values.image) "context" $) -}}
{{- end -}}

{{/*
Return redis connection info as dict
*/}}
{{- define "cloudeye-exporter.redis.config" -}}
{{- if .Values.redis.enabled }}
host: {{ printf "%s-master" (include "common.names.dependency.fullname" (dict "chartName" "redis" "chartValues" .Values.redis "context" $)) }}
port: {{ .Values.redis.master.service.ports.redis }}
{{- if .Values.redis.auth.enabled }}
{{- if .Values.redis.auth.password }}
password: {{ default "" .Values.redis.auth.password | quote }}
{{- end }}
{{- else }}
password: ""
{{- end }}
database: 0

{{- else if .Values.redisExternal.enabled }}
{{- with .Values.redisExternal }}
{{- $redisHost := required "redisExternal.redisHost is required when redisExternal in enabled" .redisHost }}
{{- $redisPort := required "redisExternal.redisPort is required when redisExternal in enabled" .redisPort }}
{{- $redisPassword := required "redisExternal.redisPassword is required when redisExternal in enabled" .redisPassword }}
{{- $redisDatabase := required "redisExternal.redisDatabase is required when redisExternal in enabled" .redisDatabase }}
host: {{ $redisHost | quote }}
port: {{ $redisPort }}
password: {{ $redisPassword | quote }}
database: {{ $redisDatabase }}
{{- end }}

{{- else }}
{{- fail "Either redis.enabled or redisExternal.enabled must be true" }}
{{- end }}
{{- end }}


{{/*
Render redis env vars
*/}}
{{- define "cloudeye-exporter.env.redis" -}}
{{- $redis := include "cloudeye-exporter.redis.config" . | fromYaml -}}
- name: REDIS_HOST
  value: {{ $redis.host | quote }}
- name: REDIS_PORT
  value: {{ $redis.port | quote }}
- name: REDIS_PASSWORD
  value: {{ $redis.password | quote }}
- name: REDIS_DB
  value: {{ $redis.database | quote }}
{{- end }}
