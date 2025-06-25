{{/*
Standard environment variables for all applications
*/}}
{{- define "k8s-app.envs" }}
env:
  - name: VERSION
    valueFrom:
      fieldRef:
        fieldPath: metadata.labels['app.kubernetes.io/version']
  - name: APP_NAME
    valueFrom:
      fieldRef:
        fieldPath: metadata.labels['app.kubernetes.io/name']
  - name: NAMESPACE
    valueFrom:
      fieldRef:
        fieldPath: metadata.namespace
  - name: MY_NODE_NAME
    valueFrom:
      fieldRef:
        fieldPath: spec.nodeName
  - name: MY_POD_NAME
    valueFrom:
      fieldRef:
        fieldPath: metadata.name
  - name: MY_POD_NAMESPACE
    valueFrom:
      fieldRef:
        fieldPath: metadata.namespace
  - name: MY_POD_IP
    valueFrom:
      fieldRef:
        fieldPath: status.podIP
  - name: MY_POD_SERVICE_ACCOUNT
    valueFrom:
      fieldRef:
        fieldPath: spec.serviceAccountName
  - name: GOMAXPROCS
    valueFrom:
      resourceFieldRef:
        resource: limits.cpu
        divisor: "1"
  - name: GOMEMLIMIT
    valueFrom:
      resourceFieldRef:
        resource: limits.memory
  - name: ENVIRONMENT
    value: {{ .root.Values.kubernetes.base.deployConfig.environment }}
  - name: CLUSTER_NAME
    value: {{ .root.Values.kubernetes.base.deployConfig.cluster }}
  - name: PROJECT_NAME
    value: {{ .root.Values.kubernetes.base.project }}
  - name: CONTAINER_HASH
    value: {{ .app.image.tag | default .root.Chart.AppVersion }}
  - name: OTEL_EXPORTER_OTLP_ENDPOINT
    value: http://open-telemetry-collector.monitoring.svc.cluster.local:4317
  - name: OTEL_EXPORTER_OTLP_PROTOCOL
    value: grpc
  - name: OTEL_RESOURCE_ATTRIBUTES
    value: service.name=$(APP_NAME).$(NAMESPACE),service.namespace=$(NAMESPACE),service.version=$(VERSION),deployment.environment={{ .root.Values.kubernetes.base.deployConfig.environment }}
  - name: OTEL_SERVICE_NAME
    value: $(APP_NAME).$(NAMESPACE)
  - name: OTEL_TRACES_EXPORTER
    value: otlp
  - name: OTEL_METRICS_EXPORTER
    value: otlp
  - name: OTEL_LOG_LEVEL
    value: info
  {{- with .root.Values.kubernetes.base.metadata.team }}
  - name: TEAM
    value: {{ . }}
  {{- end }}
  - name: MONO_REPO_URL
    value: {{ .root.Values.kubernetes.base.monoRepo.url }}
  - name: REGISTRY_URL
    value: {{ .root.Values.kubernetes.base.globalRegistry.url }}
{{- end }}

{{/*
Merge standard envs with app-specific envs
*/}}
{{- define "k8s-app.envs.merged" }}
{{- $standardEnvs := include "k8s-app.envs" . | fromYaml }}
{{- $appEnvs := dict "env" .app.env }}
{{- if .app.env }}
env:
{{- range $standardEnvs.env }}
  - name: {{ .name }}
    {{- if .value }}
    value: {{ .value | quote }}
    {{- else if .valueFrom }}
    valueFrom:
      {{- toYaml .valueFrom | nindent 6 }}
    {{- end }}
{{- end }}
{{- range .app.env }}
  - name: {{ .name }}
    {{- if .value }}
    value: {{ .value | quote }}
    {{- else if .valueFrom }}
    valueFrom:
      {{- toYaml .valueFrom | nindent 6 }}
    {{- end }}
{{- end }}
{{- else }}
{{- include "k8s-app.envs" . }}
{{- end }}
{{- end }} 