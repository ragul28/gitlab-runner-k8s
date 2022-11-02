resource "helm_release" "gitlab_runners" {
  for_each = var.gitlab_reg_token_map

  name             = each.key
  namespace        = each.key
  repository       = "https://charts.gitlab.io"
  chart            = "gitlab-runner"
  version          = var.runner_helm_version
  create_namespace = true
  set {
    name  = "runnerRegistrationToken"
    value = each.value
  }
  values = [
    <<-EOT
affinity:
  nodeAffinity:
    requiredDuringSchedulingIgnoredDuringExecution:
      nodeSelectorTerms:
        - matchExpressions:
            - key: eks.amazonaws.com/nodegroup
              operator: Exists
    preferredDuringSchedulingIgnoredDuringExecution:
      - weight: 100
        preference:
          matchExpressions:
            - key: eks.amazonaws.com/mode
              operator: In
              values:
                - system
rbac:
  create: true
  rules:
  - resources: ["configmaps", "pods", "pods/attach", "secrets", "services"]
    verbs: ["get", "list", "watch", "create", "patch", "update", "delete"]
  - apiGroups: [""]
    resources: ["pods/exec"]
    verbs: ["create", "patch", "delete"]
runners:
  name: "${each.key}"
  tags: "aws,eks-runner,docker"
  secret: "gitlab-runner"
  runUntagged: true
  config: |
    [[runners]]
      environment = ["DOCKER_HOST=tcp://docker:2376", "DOCKER_TLS_CERTDIR=/certs", "DOCKER_TLS_VERIFY=1", "DOCKER_CERT_PATH=/certs/client"]
      [runners.kubernetes]
        image = "ubuntu:20.04"
        namespace = "${each.key}"
        privileged = true
        cpu_limit = "2000m"
        cpu_request = "450m"
        memory_limit = "4Gi"
        memory_request = "1000Mi"
        service_cpu_request = "200m"
        service_memory_request = "200Mi"
        helper_cpu_request = "20m"
        helper_memory_request = "100Mi"
        [runners.cache]
          Type = "s3"
          Path = "cache"
          Shared = false
          [runners.cache.s3]
            ServerAddress = "s3.amazonaws.com"
            AuthenticationType = "iam"
            BucketName = "${var.s3_bucket_name}"
            BucketLocation =  "${var.aws_region}"
            Insecure = false
      [runners.kubernetes.node_selector]
        "eks.amazonaws.com/mode" = "builds"
      [runners.kubernetes.node_tolerations]
        "eks.amazonaws.com/nodepriority" = "NoSchedule"
      [[runners.kubernetes.volumes.empty_dir]]
        name = "docker-certs"
        mount_path = "/certs/client"
        medium = "Memory"
EOT
  ]
  set {
    name  = "gitlabUrl"
    value = var.gitlab_url
  }
  set {
    name  = "resources\\.requests\\.cpu"
    value = "50m"
  }
  set {
    name  = "resources\\.requests\\.memory"
    value = "100Mi"
  }
  set {
    name  = "concurrent"
    value = var.runner_concurrent_count
  }
  set {
    name  = "unregisterRunners"
    value = "true"
  }
}
