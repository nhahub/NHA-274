{{/*
Expand the name of the chart.
*/}}
{{- define "proshop.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
*/}}
{{- define "proshop.fullname" -}}
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
{{- define "proshop.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "proshop.labels" -}}
helm.sh/chart: {{ include "proshop.chart" . }}
{{ include "proshop.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels for app
*/}}
{{- define "proshop.selectorLabels" -}}
app.kubernetes.io/name: {{ include "proshop.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app: myapp
{{- end }}

{{/*
Selector labels for MongoDB
*/}}
{{- define "proshop.mongodb.selectorLabels" -}}
app.kubernetes.io/name: {{ include "proshop.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
app.kubernetes.io/component: mongodb
app: mongo
{{- end }}

{{/*
MongoDB connection URI
*/}}
{{- define "proshop.mongodb.uri" -}}
{{- printf "mongodb://%s:%s@%s-db-svc:%d/%s?authSource=admin" .Values.mongodb.auth.rootUsername .Values.mongodb.auth.rootPassword .Release.Name (.Values.mongodb.service.port | int) .Values.mongodb.auth.database }}
{{- end }}
