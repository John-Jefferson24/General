{{- define "snorkelflow.pvcName" -}}
{{ .Values.volumes.snorkelflowData.persistentVolumeClaimName | default (printf "%s-data" .Values.projectName) }}
{{- end -}}

{{- define "snorkelflow.registryPrefix" -}}
{{- if .Values.image.registry -}}
{{ printf "%s/" .Values.image.registry }}
{{- else -}}
{{ print "" }}
{{- end -}}
{{- end -}}

{{- define "logging.sidecar" -}}
{{- $images := .Files.Get "images.json" | fromJson -}}
{{- if ne .Values.observability.logging_stack "LEGACY" -}}
- name: vector
{{- if .Values.image.imageNames.vector }}
  image: {{ .Values.image.imageNames.vector }}
{{- else }}
  image: {{ template "snorkelflow.registryPrefix" . }}{{ $images.docker_hub_repo }}/{{ get $images.custom_images "vector" }}
{{- end }}
  args:
  - --config-dir
  - /etc/vector/
  env:
  - name: SERVICE_TYPE
    value: {{ .service_type }}
  volumeMounts:
  - name: vector-config
    mountPath: "/etc/vector"
    readOnly: true
  - name: empty-dir
    mountPath: /var/log
    subPath: log-dir
  - name: vector-data-dir
    mountPath: /var/lib/vector
{{- if .Values.services.vector.containerSecurityContext }}
  securityContext:
{{- toYaml .Values.services.vector.containerSecurityContext | nindent 4 }}
{{- end -}}
{{- end -}}
{{- end -}}

{{- define "logging.volumes" -}}
{{- if ne .Values.observability.logging_stack "LEGACY" -}}
- name: log-dir
  emptyDir:
    sizeLimit: 200Mi
- name: vector-data-dir
  emptyDir: {}
- name: vector-config
  configMap:
    name: vector-config-map
    items:
    - key: vector.yaml
      path: vector.yaml
    - key: sources.snorkel_application_log_file.yaml
      path: sources/snorkel_application_log_file.yaml
    - key: transforms.exported_snorkel_application_logs.yaml
      path: transforms/exported_snorkel_application_logs.yaml
    - key: sinks.vector.yaml
      path: sinks/vector.yaml
{{- end -}}
{{- end -}}

{{- define "logging.mounts" -}}
{{- if ne .Values.observability.logging_stack "LEGACY" -}}
{{- end -}}
{{- end -}}

{{- define "launchDarkly.envVars" -}}
{{- if ne .Values.featureFlag.launchDarklySdkKey.secretRef "" }}
- name: LAUNCHDARKLY_SDK_KEY
  valueFrom:
    secretKeyRef:
      name: {{ .Values.featureFlag.launchDarklySdkKey.secretRef }}
      key: launch_darkly_sdk_key
{{- else if ne .Values.featureFlag.launchDarklySdkKey.value "" }}
- name: LAUNCHDARKLY_SDK_KEY
  valueFrom:
    secretKeyRef:
      name: launch-darkly-secret
      key: launch_darkly_sdk_key
{{- end }}
{{- if and (eq .service_type "flow-ui") (ne .Values.featureFlag.launchDarklyClientSideId.secretRef "") }}
- name: LD_CLIENT_SIDE_ID
  valueFrom:
    secretKeyRef:
      name: {{ .Values.featureFlag.launchDarklyClientSideId.secretRef }}
      key: launch_darkly_client_side_id
{{- else if and (eq .service_type "flow-ui") (ne .Values.featureFlag.launchDarklyClientSideId.value "") }}
- name: LD_CLIENT_SIDE_ID
  valueFrom:
    secretKeyRef:
      name: launch-darkly-secret
      key: launch_darkly_client_side_id
{{- end }}
{{- if ne .Values.featureFlag.launchDarklyRelayEndpoint "" }}
- name: LAUNCHDARKLY_SERVER_ENDPOINT
  value: {{ .Values.featureFlag.launchDarklyRelayEndpoint }}
{{- end }}
{{- if and (eq .service_type "flow-ui") (ne .Values.featureFlag.launchDarklyRelayIngressEndpoint "") }} 
- name: LAUNCHDARKLY_SERVER_INGRESS_ENDPOINT
  value: {{ .Values.featureFlag.launchDarklyRelayIngressEndpoint }}
{{- end }}
{{- end -}}