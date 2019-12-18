{{/* vim: set filetype=mustache: */}}
{{/*
Expand the name of the chart.
*/}}
{{- define "amq-broker.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "amq-broker.fullname" -}}
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
{{- define "amq-broker.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Common labels
*/}}
{{- define "amq-broker.labels" -}}
helm.sh/chart: {{ include "amq-broker.chart" . }}
{{ include "amq-broker.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end -}}

{{/*
Common Selector labels
*/}}
{{- define "amq-broker.selectorLabels" -}}
app.kubernetes.io/name: {{ include "amq-broker.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end -}}


{{/*
Broker Selector labels
*/}}
{{- define "amq-broker.brokerSelectorLabels" -}}
{{ include "amq-broker.selectorLabels" . }}
app.kubernetes.io/component: broker
{{- end -}}

{{/*
Drainer Selector labels
*/}}
{{- define "amq-broker.drainerSelectorLabels" -}}
{{ include "amq-broker.selectorLabels" . }}
app.kubernetes.io/component: drainer
{{- end -}}


{{/*
Create the name of the service account to use
*/}}
{{- define "amq-broker.serviceAccountName" -}}
{{- if .Values.serviceAccount.create -}}
    {{ default (include "amq-broker.fullname" .) .Values.serviceAccount.name }}
{{- else -}}
    {{ default "default" .Values.serviceAccount.name }}
{{- end -}}
{{- end -}}

{{/*
Default userName: not used as they have to be shared by both
*/}}
{{/* Not used: https://github.com/helm/charts/issues/5167
{{- define "amq-broker.userName" -}}
{{- $random3 := randAlphaNum 3 -}}
{{- $userName := printf "%s%s" "user" $random3 -}}
{{- default $userName .Values.mq.userName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
*/}}
{{- define "amq-broker.userName" -}}
{{- default "admin" .Values.mq.userName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Default password
*/}}
{{/* Not used: https://github.com/helm/charts/issues/5167
{{- define "amq-broker.password" -}}
{{- default (randAlphaNum 8) .Values.mq.userName | trunc 63 | trimSuffix "-" -}}
{{- end -}}
*/}}
{{- define "amq-broker.password" -}}
{{- default "admin" .Values.mq.userName | trunc 63 | trimSuffix "-" -}}
{{- end -}}

{{/*
Split
*/}}
{{- define "amq-broker.split" -}}
{{- default "true" (.Values.mq.split | quote) | trunc 63 | trimSuffix "-" -}}
{{- end -}}


{{/*
Transports
*/}}
{{- define "amq-broker.transports" -}}
{{- $tmp := dict "transports" (list) -}}
{{- range $key, $value := .Values.service }}
{{- if .enabled -}} 
{{- $noop := printf "%s" $key | append $tmp.transports | set $tmp "transports" -}}
{{- end -}}
{{- end -}}
{{- join "," $tmp.transports -}}
{{- end -}}
