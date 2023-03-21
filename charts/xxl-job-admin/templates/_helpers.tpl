{{/*
Expand the name of the chart.
*/}}
{{- define "xxl-job-admin.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "xxl-job-admin.fullname" -}}
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
{{- define "xxl-job-admin.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "xxl-job-admin.labels" -}}
helm.sh/chart: {{ include "xxl-job-admin.chart" . }}
{{ include "xxl-job-admin.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "xxl-job-admin.selectorLabels" -}}
app.kubernetes.io/name: {{ include "xxl-job-admin.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- range $key, $val := .Values.podLabels }}
{{ $key }}: {{ $val | quote | lower }}
{{- end }}
app: {{ .Chart.Name }}
version: {{ .Chart.AppVersion }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "xxl-job-admin.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "xxl-job-admin.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}

{{- define "xxl-job-admin.healthCheckEndpoint" -}}
{{- $contextPath := get .Values.properties.server.servlet "context-path" }}
{{- printf "%s/%s" $contextPath "actuator/health" | replace "//" "/" }}
{{- end }}

{{/*
jdbc datasource url
*/}}
{{- define "xxl-job-admin.spring.datasource.url" -}}
{{- printf "--spring.datasource.url=jdbc:mysql://%s:%d/%s?useUnicode=true&characterEncoding=UTF-8&autoReconnect=true&serverTimezone=%s --spring.datasource.username=%s --spring.datasource.password=%s"
.Values.database.db_address (.Values.database.db_port | int) .Values.database.db_name .Values.database.serverTimezone .Values.database.user .Values.database.password}}
{{- end}}

{{/*
Istio VirtualService hosts
*/}}
{{- define "xxl-job-admin.virtualservice.hosts" }}
{{- range $host := .Values.virtualservice.hosts }}
- {{ $host | lower }}
{{- end -}}
{{- end -}}

{{/*
Istio VirtualService gateways
*/}}
{{- define "xxl-job-admin.virtualservice.gateways" }}
{{- range $gateway := .Values.virtualservice.gateways }}
- {{ $gateway |trim }}
{{- end -}}
{{- end -}}