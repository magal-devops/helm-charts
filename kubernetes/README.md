# Kubernetes Helm Templates

A comprehensive Helm chart for deploying applications to Kubernetes with support for multiple workload types, Istio service mesh, observability, and external secrets management.

## Features

- **Multiple Workload Types**: Deployment, CronJob, Job, Argo Rollout
- **Istio Service Mesh**: VirtualService, DestinationRule, PeerAuthentication, ServiceEntry, Telemetry
- **Observability**: ServiceMonitor, PrometheusRule, Grafana dashboards, distributed tracing
- **Auto-scaling**: HorizontalPodAutoscaler with multiple metrics
- **High Availability**: PodDisruptionBudget
- **Security**: NetworkPolicy, SecurityContext, RBAC
- **External Secrets**: AWS Secrets Manager, HashiCorp Vault, GCP Secret Manager, Azure Key Vault
- **Canary/Blue-Green Deployments**: Argo Rollouts with analysis
- **Standard Environment Variables**: Automated injection of common runtime variables

## Installation

```bash
# Install with default values
helm install my-app ./kubernetes

# Install with custom values
helm install my-app ./kubernetes -f values.yaml

# Upgrade existing installation
helm upgrade my-app ./kubernetes -f values.yaml
```

## Quick Start

```yaml
kubernetes:
  base:
    project: my-project
    deployConfig:
      cluster: production-cluster
      environment: production
    metadata:
      team: platform
  
  apps:
    - name: api-gateway
      kind: Deployment
      enableStandardEnvs: true
      image:
        registry: docker.io
        repository: nginx
        tag: "1.25"
      service:
        enabled: true
        port: 80
        targetPort: 80
```

## Configuration Reference

### Base Configuration

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `kubernetes.base.project` | Project name used for namespace generation | `""` | Yes |
| `kubernetes.base.deployConfig.cluster` | Target cluster name | `""` | Yes |
| `kubernetes.base.deployConfig.environment` | Environment (prod, staging, dev) | `""` | Yes |
| `kubernetes.base.metadata.team` | Team responsible for the application | `""` | No |
| `kubernetes.base.monoRepo.url` | Git repository URL | `""` | No |
| `kubernetes.base.monoRepo.appsFolder` | Apps folder in the repository | `""` | No |
| `kubernetes.base.monoRepo.revision` | Git revision/branch | `main` | No |
| `kubernetes.base.globalRegistry.url` | Container registry URL | `""` | No |

### Application Configuration

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `name` | Application name | `""` | Yes |
| `kind` | Workload type (Deployment, CronJob, Job, Rollout) | `Deployment` | Yes |
| `enableStandardEnvs` | Enable standard environment variables injection | `false` | No |
| `replicas` | Number of replicas | `1` | No |
| `image.registry` | Container registry | `""` | Yes |
| `image.repository` | Container image repository | `""` | Yes |
| `image.tag` | Container image tag | `""` | Yes |
| `image.pullPolicy` | Image pull policy | `IfNotPresent` | No |
| `command` | Container command override | `[]` | No |
| `args` | Container arguments override | `[]` | No |

### Service Configuration

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `service.enabled` | Enable service creation | `false` | No |
| `service.type` | Service type (ClusterIP, NodePort, LoadBalancer) | `ClusterIP` | No |
| `service.port` | Service port | `80` | No |
| `service.targetPort` | Target container port | `80` | No |
| `service.appProtocol` | Application protocol | `http` | No |
| `service.annotations` | Service annotations | `{}` | No |
| `service.labels` | Service labels | `{}` | No |

### Resources and Scaling

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `resources.limits.cpu` | CPU limit | `""` | No |
| `resources.limits.memory` | Memory limit | `""` | No |
| `resources.requests.cpu` | CPU request | `""` | No |
| `resources.requests.memory` | Memory request | `""` | No |
| `hpa.enabled` | Enable HorizontalPodAutoscaler | `false` | No |
| `hpa.minReplicas` | Minimum replicas | `1` | No |
| `hpa.maxReplicas` | Maximum replicas | `10` | No |
| `hpa.targetCPUUtilizationPercentage` | CPU target percentage | `80` | No |
| `hpa.targetMemoryUtilizationPercentage` | Memory target percentage | `80` | No |
| `pdb.enabled` | Enable PodDisruptionBudget | `false` | No |
| `pdb.minAvailable` | Minimum available pods | `1` | No |
| `pdb.maxUnavailable` | Maximum unavailable pods | `""` | No |

### Health Checks

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `readinessProbe.httpGet.path` | Readiness probe HTTP path | `""` | No |
| `readinessProbe.httpGet.port` | Readiness probe HTTP port | `""` | No |
| `readinessProbe.initialDelaySeconds` | Initial delay before probing | `0` | No |
| `readinessProbe.periodSeconds` | Probe frequency | `10` | No |
| `readinessProbe.timeoutSeconds` | Probe timeout | `1` | No |
| `readinessProbe.failureThreshold` | Failure threshold | `3` | No |
| `livenessProbe.httpGet.path` | Liveness probe HTTP path | `""` | No |
| `livenessProbe.httpGet.port` | Liveness probe HTTP port | `""` | No |
| `livenessProbe.initialDelaySeconds` | Initial delay before probing | `0` | No |
| `livenessProbe.periodSeconds` | Probe frequency | `10` | No |
| `livenessProbe.timeoutSeconds` | Probe timeout | `1` | No |
| `livenessProbe.failureThreshold` | Failure threshold | `3` | No |

### Security

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `serviceAccount.create` | Create service account | `false` | No |
| `serviceAccount.name` | Service account name | `""` | No |
| `serviceAccount.annotations` | Service account annotations | `{}` | No |
| `serviceAccount.automountServiceAccountToken` | Auto-mount service account token | `true` | No |
| `securityContext.runAsNonRoot` | Run as non-root user | `false` | No |
| `securityContext.runAsUser` | User ID to run as | `""` | No |
| `securityContext.fsGroup` | File system group ID | `""` | No |
| `securityContext.allowPrivilegeEscalation` | Allow privilege escalation | `true` | No |
| `securityContext.readOnlyRootFilesystem` | Read-only root filesystem | `false` | No |
| `securityContext.capabilities.drop` | Linux capabilities to drop | `[]` | No |

### Istio Service Mesh

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `virtualService.enabled` | Enable VirtualService | `false` | No |
| `virtualService.name` | VirtualService name | `""` | No |
| `virtualService.gateways` | Gateway references | `[]` | No |
| `virtualService.hosts` | Virtual hosts | `[]` | No |
| `virtualService.http` | HTTP routing rules | `[]` | No |
| `destinationRule.enabled` | Enable DestinationRule | `false` | No |
| `destinationRule.name` | DestinationRule name | `""` | No |
| `destinationRule.host` | Destination host | `""` | No |
| `destinationRule.trafficPolicy` | Traffic policy configuration | `{}` | No |
| `destinationRule.subsets` | Traffic subsets | `[]` | No |
| `peerAuthentication.enabled` | Enable PeerAuthentication | `false` | No |
| `peerAuthentication.mtls.mode` | mTLS mode (STRICT, PERMISSIVE, DISABLE) | `STRICT` | No |
| `serviceEntry.enabled` | Enable ServiceEntry | `false` | No |
| `serviceEntry.entries` | External service entries | `[]` | No |
| `telemetry.enabled` | Enable Telemetry | `false` | No |

### CronJob Configuration

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `cronJob.schedule` | Cron schedule expression | `""` | Yes (for CronJob) |
| `cronJob.timeZone` | Time zone | `""` | No |
| `cronJob.concurrencyPolicy` | Concurrency policy (Allow, Forbid, Replace) | `Allow` | No |
| `cronJob.suspend` | Suspend cron job execution | `false` | No |
| `cronJob.successfulJobsHistoryLimit` | Successful jobs history limit | `3` | No |
| `cronJob.failedJobsHistoryLimit` | Failed jobs history limit | `1` | No |
| `cronJob.startingDeadlineSeconds` | Starting deadline seconds | `""` | No |
| `cronJob.backoffLimit` | Job backoff limit | `6` | No |
| `cronJob.activeDeadlineSeconds` | Job active deadline seconds | `""` | No |
| `cronJob.ttlSecondsAfterFinished` | TTL seconds after job finished | `""` | No |
| `cronJob.restartPolicy` | Container restart policy (Never, OnFailure) | `OnFailure` | No |
| `cronJob.enableStandardEnvs` | Enable standard environment variables | `false` | No |

### Job Configuration

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `job.backoffLimit` | Job backoff limit | `6` | No |
| `job.activeDeadlineSeconds` | Job active deadline seconds | `""` | No |
| `job.ttlSecondsAfterFinished` | TTL seconds after job finished | `""` | No |
| `job.completions` | Number of completions | `1` | No |
| `job.parallelism` | Number of parallel pods | `1` | No |
| `job.completionMode` | Completion mode (NonIndexed, Indexed) | `NonIndexed` | No |
| `job.suspend` | Suspend job execution | `false` | No |
| `job.restartPolicy` | Container restart policy (Never, OnFailure) | `Never` | No |
| `job.enableStandardEnvs` | Enable standard environment variables | `false` | No |

### Argo Rollout Configuration

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `rollout.revisionHistoryLimit` | Revision history limit | `10` | No |
| `rollout.progressDeadlineSeconds` | Progress deadline seconds | `600` | No |
| `rollout.paused` | Pause rollout | `false` | No |
| `rollout.strategy.type` | Strategy type (canary, blueGreen) | `canary` | No |
| `rollout.strategy.canary.maxSurge` | Max surge for canary | `25%` | No |
| `rollout.strategy.canary.maxUnavailable` | Max unavailable for canary | `25%` | No |
| `rollout.strategy.canary.steps` | Canary deployment steps | `[]` | No |
| `rollout.strategy.canary.canaryService` | Canary service name | `""` | No |
| `rollout.strategy.canary.stableService` | Stable service name | `""` | No |
| `rollout.strategy.canary.trafficRouting` | Traffic routing configuration | `{}` | No |
| `rollout.strategy.canary.analysis` | Analysis configuration | `{}` | No |
| `rollout.strategy.blueGreen.activeService` | Active service for blue-green | `""` | No |
| `rollout.strategy.blueGreen.previewService` | Preview service for blue-green | `""` | No |
| `rollout.strategy.blueGreen.autoPromotionEnabled` | Auto promotion enabled | `true` | No |
| `rollout.strategy.blueGreen.scaleDownDelaySeconds` | Scale down delay seconds | `30` | No |
| `rollout.enableStandardEnvs` | Enable standard environment variables | `false` | No |

### Monitoring and Observability

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `serviceMonitor.enabled` | Enable ServiceMonitor | `false` | No |
| `serviceMonitor.name` | ServiceMonitor name | `""` | No |
| `serviceMonitor.namespace` | ServiceMonitor namespace | `""` | No |
| `serviceMonitor.endpoints` | Monitoring endpoints | `[]` | No |
| `serviceMonitor.labels` | ServiceMonitor labels | `{}` | No |
| `prometheusRule.enabled` | Enable PrometheusRule | `false` | No |
| `prometheusRule.name` | PrometheusRule name | `""` | No |
| `prometheusRule.groups` | Alert rule groups | `[]` | No |
| `prometheusRule.labels` | PrometheusRule labels | `{}` | No |

### External Secrets

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `externalSecret.enabled` | Enable ExternalSecret | `false` | No |
| `externalSecret.name` | ExternalSecret name | `""` | No |
| `externalSecret.refreshInterval` | Refresh interval | `1h` | No |
| `externalSecret.secretStoreRef.name` | SecretStore reference name | `""` | Yes (if enabled) |
| `externalSecret.secretStoreRef.kind` | SecretStore reference kind | `SecretStore` | No |
| `externalSecret.target.name` | Target secret name | `""` | No |
| `externalSecret.target.creationPolicy` | Creation policy (Owner, Merge, None) | `Owner` | No |
| `externalSecret.data` | Secret data mappings | `[]` | No |
| `secretStore.enabled` | Enable SecretStore | `false` | No |
| `secretStore.name` | SecretStore name | `""` | No |
| `secretStore.provider.aws.service` | AWS service (SecretsManager, ParameterStore) | `SecretsManager` | No |
| `secretStore.provider.aws.region` | AWS region | `""` | Yes (for AWS) |
| `secretStore.provider.aws.role` | AWS IAM role | `""` | No |
| `secretStore.provider.aws.auth` | AWS authentication configuration | `{}` | No |
| `secretStore.provider.vault.server` | Vault server URL | `""` | Yes (for Vault) |
| `secretStore.provider.vault.path` | Vault path | `""` | Yes (for Vault) |
| `secretStore.provider.gcpsm.projectID` | GCP project ID | `""` | Yes (for GCP) |
| `secretStore.provider.azurekv.vaultUrl` | Azure Key Vault URL | `""` | Yes (for Azure) |
| `clusterSecretStore.enabled` | Enable ClusterSecretStore | `false` | No |

### Analysis Templates (Argo Rollouts)

| Parameter | Description | Default | Required |
|-----------|-------------|---------|----------|
| `analysisTemplates` | Custom analysis templates | `[]` | No |

Built-in analysis templates available:
- `success-rate`: Monitors HTTP success rate (>95% success, <90% failure)
- `latency`: Monitors response latency (p95 ≤500ms success, >1000ms failure)
- `error-rate`: Monitors error rate (≤5% success, >10% failure)
- `cpu-usage`: Monitors CPU usage (≤80% success, >95% failure)
- `memory-usage`: Monitors memory usage (≤80% success, >90% failure)

### Environment Variables

When `enableStandardEnvs: true` is set, the following environment variables are automatically injected:

| Variable | Description | Source |
|----------|-------------|---------|
| `VERSION` | Application version | Pod label |
| `APP_NAME` | Application name | Pod label |
| `NAMESPACE` | Pod namespace | Pod metadata |
| `MY_NODE_NAME` | Node name | Pod spec |
| `MY_POD_NAME` | Pod name | Pod metadata |
| `MY_POD_IP` | Pod IP address | Pod status |
| `MY_POD_SERVICE_ACCOUNT` | Service account name | Pod spec |
| `GOMAXPROCS` | Go max processes | CPU limits |
| `GOMEMLIMIT` | Go memory limit | Memory limits |
| `ENVIRONMENT` | Environment name | Values file |
| `CLUSTER_NAME` | Cluster name | Values file |
| `PROJECT_NAME` | Project name | Values file |
| `TEAM` | Team name | Values file |
| `CONTAINER_HASH` | Container image tag | Image tag |
| `OTEL_EXPORTER_OTLP_ENDPOINT` | OpenTelemetry endpoint | Default config |
| `OTEL_SERVICE_NAME` | OpenTelemetry service name | Generated |
| `MONO_REPO_URL` | Repository URL | Values file |
| `REGISTRY_URL` | Registry URL | Values file |

## Examples

### Basic Deployment

```yaml
kubernetes:
  apps:
    - name: web-app
      kind: Deployment
      image:
        registry: docker.io
        repository: nginx
        tag: "1.25"
      service:
        enabled: true
        port: 80
        targetPort: 80
```

### CronJob Example

```yaml
kubernetes:
  apps:
    - name: backup-job
      kind: CronJob
      image:
        registry: docker.io
        repository: postgres
        tag: "15"
      cronJob:
        schedule: "0 2 * * *"
        timeZone: "UTC"
```

### Canary Deployment with Istio

```yaml
kubernetes:
  apps:
    - name: api-service
      kind: Rollout
      image:
        registry: docker.io
        repository: myapp/api
        tag: "v2.0.0"
      rollout:
        strategy:
          type: canary
          canary:
            steps:
              - setWeight: 20
              - pause: { duration: 30s }
              - setWeight: 50
              - pause: { duration: 30s }
            analysis:
              templates:
                - templateName: success-rate
                - templateName: latency
      virtualService:
        enabled: true
        hosts:
          - api.example.com
```

### External Secrets with AWS

```yaml
kubernetes:
  apps:
    - name: secure-app
      kind: Deployment
      externalSecret:
        enabled: true
        secretStoreRef:
          name: aws-secrets-store
        data:
          - secretKey: database-password
            remoteRef:
              key: myapp/database
              property: password
      secretStore:
        enabled: true
        provider:
          aws:
            service: SecretsManager
            region: us-east-1
            auth:
              jwt:
                serviceAccountRef:
                  name: external-secrets-sa
```

## License

This project is licensed under the MIT License - see the LICENSE file for details. 