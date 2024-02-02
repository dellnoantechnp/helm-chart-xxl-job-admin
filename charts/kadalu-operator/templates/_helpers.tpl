{{/* vim: set filetype=mustache: */}}

{{/*
Kadalu proper image repository
*/}}
{{- define "common.images.image" -}}
{{- printf "%s/%s" .Values.global.image.registry .Values.global.image.repository }}
{{- end -}}


{{/*
Kadalu KADALU_VERSION
*/}}
{{- define "common.version" -}}
{{- if eq .Chart.Version "0.0.0-0" -}}
{{ print "devel" }}
{{- else -}}
{{ .Chart.AppVersion }}
{{- end -}}
{{- end -}}

{{/*
Kadalu KUBELET_DIR
*/}}
{{- define "common.configs.kubeletDir" -}}
{{- if (eq .Values.global.kubernetesDistro "microk8s") -}}
{{ default "/var/snap/microk8s/common/var/lib/kubelet" .Values.global.kubeletDir }}
{{- else -}}
{{ default "/var/lib/kubelet" .Values.global.kubeletDir }}
{{- end -}}
{{- end -}}

{{/*
Renders a external gluster_host value that contains template.
Usage:
{{- include "external.gluster_hosts.render" ( dict "value" .Values.path.to.the.Value "context" $) }}
*/}}
{{- define "external.gluster_hosts.render" -}}
{{- if typeIs "string" .value }}
gluster_host: {{ tpl .value .context | quote }}
{{- else }}
gluster_hosts:
{{ tpl (.value | toYaml ) .context | indent 2 }}
{{- end }}
{{- end -}}

{{/*
Return Kadalu-operator Namespace to use
*/}}
{{- define "kadalu-operator.namespace" -}}
{{- if .Values.namespaceOverride -}}
    {{- .Values.namespaceOverride -}}
{{- else -}}
    {{- .Release.Namespace -}}
{{- end -}}
{{- end -}}