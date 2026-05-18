{{/*
Resolve the full image reference (registry/repository:tag) for a given image config.
Resolution order: global.imageRegistry > image.registry > (no prefix).
Call with: include "fleet-management.image" (dict "global" .Values.global "image" .Values.<component>.image)
*/}}
{{- define "fleet-management.image" -}}
{{- $registry := .global.imageRegistry | default .image.registry -}}
{{- if $registry -}}
{{- printf "%s/%s:%s" $registry .image.repository .image.tag -}}
{{- else -}}
{{- printf "%s:%s" .image.repository .image.tag -}}
{{- end -}}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "fleet-management.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "fleet-management.fullname" -}}
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
Namespace for generated references.
Always uses the Helm release namespace.
*/}}
{{- define "fleet-management.namespaceName" -}}
{{- .Release.Namespace }}
{{- end }}

{{/*
Resource name with proper truncation for Kubernetes 63-character limit.
Takes a dict with:
  - .suffix: Resource name suffix (e.g., "metrics", "webhook")
  - .context: Template context (root context with .Values, .Release, etc.)
Dynamically calculates safe truncation to ensure total name length <= 63 chars.
*/}}
{{- define "fleet-management.resourceName" -}}
{{- $fullname := include "fleet-management.fullname" .context }}
{{- $suffix := .suffix }}
{{- $maxLen := sub 62 (len $suffix) | int }}
{{- if gt (len $fullname) $maxLen }}
{{- printf "%s-%s" (trunc $maxLen $fullname | trimSuffix "-") $suffix | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" $fullname $suffix | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Common labels applied to all resources.
Includes recommended Kubernetes and Helm labels.
*/}}
{{- define "fleet-management.labels" -}}
helm.sh/chart: {{ printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
app.kubernetes.io/name: {{ include "fleet-management.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels used in matchLabels and Service selectors.
These must remain stable — changing them requires deleting and recreating
Deployments (selectors are immutable).
*/}}
{{- define "fleet-management.selectorLabels" -}}
app.kubernetes.io/name: {{ include "fleet-management.name" . }}
control-plane: controller-manager
{{- end }}

{{/*
Selector labels for the Envoy gateway Deployment and Service.
Uses app.kubernetes.io/component: gateway to avoid conflicting with the manager's
control-plane: controller-manager selector.
*/}}
{{- define "fleet-management.gatewaySelectorLabels" -}}
app.kubernetes.io/name: {{ include "fleet-management.name" . }}
app.kubernetes.io/component: gateway
{{- end }}

{{/*
Fully-qualified DNS name of the internal Connect-RPC API Service.
Used as the Envoy upstream cluster address so the gateway can proxy to the API.
*/}}
{{- define "fleet-management.gatewayUpstreamHost" -}}
{{- include "fleet-management.resourceName" (dict "suffix" "api" "context" .) }}.{{ .Release.Namespace }}.svc.cluster.local
{{- end }}

{{/*
Compute the final Envoy bootstrap config by:
  1. Rendering gateway.config (a templated YAML string) with tpl
  2. Parsing the result with fromYaml
  3. Deep-merging gateway.structuredConfig on top (structuredConfig wins)
  4. Converting back to YAML
  5. Running tpl a second time to resolve any template functions in the merged output
This mirrors Loki's loki.calculatedConfig pattern and allows users to either tweak
individual Envoy fields via structuredConfig or replace the entire config via gateway.config.
*/}}
{{- define "fleet-management.gatewayCalculatedConfig" -}}
{{ tpl (mergeOverwrite (tpl .Values.gateway.config . | fromYaml) .Values.gateway.structuredConfig | toYaml) . }}
{{- end }}
