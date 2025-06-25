{{/* vim: set filetype=mustache: */}}
{{/*
Create namespace name based on project and environment
*/}}
{{- define "k8s-app.namespace" -}}
{{- printf "%s-%s" .Values.kubernetes.base.project .Values.kubernetes.base.deployConfig.environment }}
{{- end }}

{{/*
Expand the name of the chart.
*/}}
{{- define "k8s-app.name" -}}
{{- .appName | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
*/}}
{{- define "k8s-app.fullname" -}}
{{- if .root.Values.fullnameOverride }}
{{- .root.Values.fullnameOverride | trunc 63 | trimSuffix "-" }}
{{- else }}
{{- printf "%s-%s" .root.Release.Name .appName | trunc 63 | trimSuffix "-" }}
{{- end }}
{{- end }}

{{/*
Create chart name and version as used by the chart label.
*/}}
{{- define "k8s-app.chart" -}}
{{- printf "%s-%s" .root.Chart.Name .root.Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "k8s-app.labels" -}}
helm.sh/chart: {{ include "k8s-app.chart" . }}
{{ include "k8s-app.selectorLabels" . }}
{{- if .root.Chart.AppVersion }}
app.kubernetes.io/version: {{ .root.Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .root.Release.Service }}
{{- with .root.Values.kubernetes.base.metadata }}
{{- range $key, $value := . }}
{{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "k8s-app.selectorLabels" -}}
app.kubernetes.io/name: {{ include "k8s-app.name" . }}
app.kubernetes.io/instance: {{ .root.Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "k8s-app.serviceAccountName" -}}
{{- if .app.serviceAccount.create }}
{{- default (include "k8s-app.fullname" .) .app.serviceAccount.name }}
{{- else }}
{{- default "default" .app.serviceAccount.name }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for HPA.
*/}}
{{- define "k8s-app.hpa.apiVersion" -}}
{{- if .root.Capabilities.APIVersions.Has "autoscaling/v2" }}
{{- print "autoscaling/v2" }}
{{- else }}
{{- print "autoscaling/v2beta2" }}
{{- end }}
{{- end }}

{{/*
Return the appropriate apiVersion for PodDisruptionBudget.
*/}}
{{- define "k8s-app.pdb.apiVersion" -}}
{{- if .root.Capabilities.APIVersions.Has "policy/v1/PodDisruptionBudget" }}
{{- print "policy/v1" }}
{{- else }}
{{- print "policy/v1beta1" }}
{{- end }}
{{- end }}

{{/*
Base labels for resources
*/}}
{{- define "k8s-app.baseLabels" -}}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- with .Values.kubernetes.base.metadata }}
{{- range $key, $value := . }}
{{ $key }}: {{ $value | quote }}
{{- end }}
{{- end }}
{{- end }} 