{{- define "finserv-service.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{- define "finserv-service.fullname" -}}
{{- printf "%s-%s" .Release.Name (include "finserv-service.name" .) | trunc 63 | trimSuffix "-" }}
{{- end }}
