{{- define "instance.configmap.tpl" -}}
{{- /*gotype: */ -}}
{{ tpl (.Files.Get "configs/instance.properties") . }}
{{- end -}}