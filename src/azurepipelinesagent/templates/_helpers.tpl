{{/*
Expand the name of the chart.
*/}}
{{- define "azure-pipelines-agent.name" -}}
{{- default .Chart.Name .Values.nameOverride | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Create a default fully qualified app name.
We truncate at 63 chars because some Kubernetes name fields are limited to this (by the DNS naming spec).
If release name contains chart name it will be used as a full name.
*/}}
{{- define "azure-pipelines-agent.fullname" -}}
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
{{- define "azure-pipelines-agent.chart" -}}
{{- printf "%s-%s" .Chart.Name .Chart.Version | replace "+" "_" | trunc 63 | trimSuffix "-" }}
{{- end }}

{{/*
Common labels
*/}}
{{- define "azure-pipelines-agent.labels" -}}
helm.sh/chart: {{ include "azure-pipelines-agent.chart" . }}
{{ include "azure-pipelines-agent.selectorLabels" . }}
{{- if .Chart.AppVersion }}
app.kubernetes.io/version: {{ .Chart.AppVersion | quote }}
{{- end }}
app.kubernetes.io/managed-by: {{ .Release.Service }}
{{- end }}

{{/*
Selector labels
*/}}
{{- define "azure-pipelines-agent.selectorLabels" -}}
app.kubernetes.io/name: {{ include "azure-pipelines-agent.name" . }}
app.kubernetes.io/instance: {{ .Release.Name }}
{{- end }}

{{/*
Create the name of the service account to use
*/}}
{{- define "azure-pipelines-agent.serviceAccountName" -}}
{{- if .Values.serviceAccount.create }}
{{- default (include "azure-pipelines-agent.fullname" .) .Values.serviceAccount.name }}
{{- else }}
{{- default "default" .Values.serviceAccount.name }}
{{- end }}
{{- end }}


{{/*
Add volumes to the agent pod.
*/}}
{{- define "azure-pipelines-agent.volumes" -}}
{{- if or .Values.devops.agent.mountDocker .Values.extraVolumes -}}
volumes:
{{- if .Values.extraVolumes }}
{{- with .Values.extraVolumes }}
{{ toYaml . }}
{{- end }}
{{- end }}
{{- if .Values.devops.agent.mountDocker }}
- name: dockersock
  hostPath:
    path: /var/run/docker.sock
{{- end }}
{{- end }}
{{- end }}


{{/*
Add volume mounts to the agent container.
*/}}
{{- define "azure-pipelines-agent.volumeMounts" -}}
{{- if or .Values.devops.agent.mountDocker .Values.volumeMounts -}}
volumeMounts:
{{- if .Values.devops.agent.mountDocker }}
- name: dockersock
  mountPath: /var/run/docker.sock
{{- end }}
{{- if .Values.volumeMounts }}
{{- with .Values.volumeMounts }}
{{ toYaml . }}
{{- end }}
{{- end }}
{{- end }}
{{- end }}