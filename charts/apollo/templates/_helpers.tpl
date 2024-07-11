{{/* vim: set filetype=mustache: */}}

{{- define "apollo.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "apollo.fullname" -}}
{{- if .Values.fullnameOverride -}}
{{- .Values.fullnameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- $name := default .Chart.Name .Values.nameOverride -}}
{{- if contains $name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name $name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "apollo.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "apollo.service.labels" -}}
app.kubernetes.io/name: {{ include "apollo.name" . }}
helm.sh/chart: {{ include "apollo.chart" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}



{{/*
Service name for configdb
*/}}
{{- define "apollo.configdb.serviceName" -}}
{{- if .Values.db.configdb.service.enabled -}}
{{- if .Values.db.configdb.service.fullNameOverride -}}
{{- .Values.db.configdb.service.fullNameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Values.db.configdb.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- .Values.db.configdb.host -}}
{{- end -}}
{{- end -}}

{{/*
Service port for configdb
*/}}
{{- define "apollo.configdb.servicePort" -}}
{{- if .Values.db.configdb.service.enabled -}}
{{- .Values.db.configdb.service.port -}}
{{- else -}}
{{- .Values.db.configdb.port -}}
{{- end -}}
{{- end -}}

{{/*
Full name for config service
*/}}
{{- define "apollo.configService.fullName" -}}
{{- if .Values.configService.fullNameOverride -}}
{{- .Values.configService.fullNameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if contains .Values.configService.name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Values.configService.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Service name for config service
*/}}
{{- define "apollo.configService.serviceName" -}}
{{- if .Values.configService.service.fullNameOverride -}}
{{- .Values.configService.service.fullNameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{ include "apollo.configService.fullName" .}}
{{- end -}}
{{- end -}}

{{/*
Config service url to be accessed by apollo-client
*/}}
{{- define "apollo.configService.serviceUrl" -}}
{{- if .Values.configService.config.configServiceUrlOverride -}}
{{ .Values.configService.config.configServiceUrlOverride }}
{{- else -}}
http://{{ include "apollo.configService.serviceName" .}}.{{ .Release.Namespace }}:{{ .Values.configService.service.port }}{{ .Values.configService.config.contextPath }}
{{- end -}}
{{- end -}}

{{/*
Full name for admin service
*/}}
{{- define "apollo.adminService.fullName" -}}
{{- if .Values.adminService.fullNameOverride -}}
{{- .Values.adminService.fullNameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if contains .Values.adminService.name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Values.adminService.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Service name for admin service
*/}}
{{- define "apollo.adminService.serviceName" -}}
{{- if .Values.adminService.service.fullNameOverride -}}
{{- .Values.adminService.service.fullNameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{ include "apollo.adminService.fullName" .}}
{{- end -}}
{{- end -}}

{{/*
Admin service url to be accessed by apollo-portal
*/}}
{{- define "apollo.adminService.serviceUrl" -}}
{{- if .Values.configService.config.adminServiceUrlOverride -}}
{{ .Values.configService.config.adminServiceUrlOverride -}}
{{- else -}}
http://{{ include "apollo.adminService.serviceName" .}}.{{ .Release.Namespace }}:{{ .Values.adminService.service.port }}{{ .Values.adminService.config.contextPath }}
{{- end -}}
{{- end -}}




{{/*
Portal
*/}}
{{/* vim: set filetype=mustache: */}}

{{/*
Full name for apollo-portal
*/}}
{{- define "apollo.portal.fullName" -}}
{{- if .Values.fullNameOverride -}}
{{- .Values.fullNameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- if contains .Values.portal.name .Release.Name -}}
{{- .Release.Name | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Values.portal.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- end -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "apollo.portal.labels" -}}
{{- if .Chart.AppVersion -}}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
{{- end -}}

{{/*
Service name for portal
*/}}
{{- define "apollo.portal.serviceName" -}}
{{- if .Values.portal.service.fullNameOverride -}}
{{- .Values.portal.service.fullNameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{ include "apollo.portal.fullName" .}}
{{- end -}}
{{- end -}}

{{/*
Service name for portaldb
*/}}
{{- define "apollo.portaldb.serviceName" -}}
{{- if .Values.db.portaldb.service.enabled -}}
{{- if .Values.db.portaldb.service.fullNameOverride -}}
{{- .Values.db.portaldb.service.fullNameOverride | trunc 63 | trimSuffix "-" -}}
{{- else -}}
{{- printf "%s-%s" .Release.Name .Values.db.portaldb.name | trunc 63 | trimSuffix "-" -}}
{{- end -}}
{{- else -}}
{{- .Values.db.portaldb.host -}}
{{- end -}}
{{- end -}}

{{/*
Service port for portaldb
*/}}
{{- define "apollo.portaldb.servicePort" -}}
{{- if .Values.db.portaldb.service.enabled -}}
{{- .Values.db.portaldb.service.port -}}
{{- else -}}
{{- .Values.db.portaldb.port -}}
{{- end -}}
{{- end -}}
