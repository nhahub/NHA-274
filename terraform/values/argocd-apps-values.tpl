applications:

  metrics-server:
    namespace: argocd
    project: default
    source:
      chart: metrics-server
      repoURL: https://kubernetes-sigs.github.io/metrics-server/
      targetRevision: "*"
    metadata:
      annotations:
        argocd.argoproj.io/sync-wave: "-5"
    destination:
      namespace: kube-system
      server: https://kubernetes.default.svc
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true

  ebs-eci:
    namespace: argocd
    project: default
    source:
      chart: aws-ebs-csi-driver
      repoURL: https://kubernetes-sigs.github.io/aws-ebs-csi-driver
      targetRevision: "*"
      helm:
        values: |
          controller:
            serviceAccount:
              create: true
              name: ebs-sa

          storageClasses:
            - name: ebs-gp2
              annotations:
                storageclass.kubernetes.io/is-default-class: "true"
              volumeBindingMode: WaitForFirstConsumer
              parameters:
                type: gp2
                encrypted: "true"
    metadata:
      annotations:
        argocd.argoproj.io/sync-wave: "-4"
    destination:
      namespace: kube-system
      server: https://kubernetes.default.svc
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true


  load-balancer-controller:
    namespace: argocd
    project: default
    source:
      chart: aws-load-balancer-controller
      repoURL: https://aws.github.io/eks-charts
      targetRevision: "*"
      helm:
        values: |
          clusterName: ${cluster_name}
          serviceAccount:
            create: true
            name: lbc-sa

          vpcId: ${vpc_id}
          region: ${aws_region}
    metadata:
      annotations:
        argocd.argoproj.io/sync-wave: "-3"
    destination:
      namespace: kube-system
      server: https://kubernetes.default.svc
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true

  external-secrets:
    namespace: argocd
    project: default
    source:
      chart: external-secrets
      repoURL: https://charts.external-secrets.io
      targetRevision: "*"
      helm:
        values: |
          installCRDs: true
          webhook:
            create: false
          serviceAccount:
            create: true
            name: eso-sa
    destination:
      namespace: eso
      server: https://kubernetes.default.svc
    metadata:
      annotations:
        argocd.argoproj.io/sync-wave: "-2"
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true
        - Replace=true


  external-secrets-manifests:
    namespace: argocd
    project: default
    source:
      path: k8s/eso
      repoURL: https://github.com/nhahub/NHA-274.git
      targetRevision: HEAD
    destination:
      namespace: eso
      server: https://kubernetes.default.svc
    metadata:
      annotations:
        argocd.argoproj.io/sync-wave: "-2"
    syncPolicy:
      automated:
        prune: true
        selfHeal: true


  external-dns:
    namespace: argocd
    project: default
    source:
      chart: external-dns
      repoURL: https://kubernetes-sigs.github.io/external-dns/
      targetRevision: "*"
      helm:
        values: |
          provider: aws

          aws:
            region: ${aws_region}
            zoneType: public

          domainFilters:
            - ${panel_domain}
            - ${users_domain}

          serviceAccount:
            create: true
            name: edns-sa

          sources:
            - service
            - ingress

          policy: sync
          registry: txt
          txtOwnerId: ${cluster_name}
          txtPrefix: external-dns-

          interval: 1m

    metadata:
      annotations:
        argocd.argoproj.io/sync-wave: "-1"
    destination:
      namespace: kube-system
      server: https://kubernetes.default.svc
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true


  prometheus:
    namespace: argocd
    project: default
    source:
      chart: prometheus
      repoURL: https://prometheus-community.github.io/helm-charts
      targetRevision: "25.*"
      helm:
        values: |
          server:
            persistentVolume:
              enabled: false
            
            service:
              type: ClusterIP
              port: 80
            
            ingress:
              enabled: true
              ingressClassName: alb
              annotations:
                alb.ingress.kubernetes.io/scheme: internet-facing
                alb.ingress.kubernetes.io/target-type: ip
                alb.ingress.kubernetes.io/group.name: shared-alb
                alb.ingress.kubernetes.io/group.order: "5"
                alb.ingress.kubernetes.io/healthcheck-path: /monitoring/prometheus/-/healthy
                alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
                alb.ingress.kubernetes.io/success-codes: "200"
              hosts:
                - ${panel_domain}
              path: /monitoring/prometheus
              pathType: Prefix

            prefixURL: /monitoring/prometheus
            baseURL: http://${panel_domain}/monitoring/prometheus

          alertmanager:
            enabled: false

          pushgateway:
            enabled: false

          kube-state-metrics:
            enabled: true

          prometheus-node-exporter:
            enabled: true

          serverFiles:
            prometheus.yml:
              scrape_configs:
                - job_name: prometheus
                  static_configs:
                    - targets:
                      - localhost:9090

                - job_name: 'kubernetes-nodes'
                  kubernetes_sd_configs:
                    - role: node
                  relabel_configs:
                    - action: labelmap
                      regex: __meta_kubernetes_node_label_(.+)

                - job_name: 'kubernetes-pods'
                  kubernetes_sd_configs:
                    - role: pod
                  relabel_configs:
                    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_scrape]
                      action: keep
                      regex: true
                    - source_labels: [__meta_kubernetes_pod_annotation_prometheus_io_path]
                      action: replace
                      target_label: __metrics_path__
                      regex: (.+)
                    - source_labels: [__address__, __meta_kubernetes_pod_annotation_prometheus_io_port]
                      action: replace
                      regex: ([^:]+)(?::\d+)?;(\d+)
                      replacement: $1:$2
                      target_label: __address__
                    - action: labelmap
                      regex: __meta_kubernetes_pod_label_(.+)
                    - source_labels: [__meta_kubernetes_namespace]
                      action: replace
                      target_label: kubernetes_namespace
                    - source_labels: [__meta_kubernetes_pod_name]
                      action: replace
                      target_label: kubernetes_pod_name

                - job_name: 'kube-state-metrics'
                  static_configs:
                    - targets: ['prometheus-kube-state-metrics.monitoring.svc.cluster.local:8080']

                - job_name: 'node-exporter'
                  kubernetes_sd_configs:
                    - role: endpoints
                  relabel_configs:
                    - source_labels: [__meta_kubernetes_endpoints_name]
                      regex: 'prometheus-prometheus-node-exporter'
                      action: keep

                - job_name: 'argocd-application-controller'
                  metrics_path: /metrics
                  static_configs:
                    - targets:
                      - 'argocd-application-controller-metrics.argocd.svc.cluster.local:8082'

                - job_name: 'argocd-server'
                  metrics_path: /metrics
                  static_configs:
                    - targets:
                      - 'argocd-server-metrics.argocd.svc.cluster.local:8083'

                - job_name: 'argocd-repo-server'
                  metrics_path: /metrics
                  static_configs:
                    - targets:
                      - 'argocd-repo-server-metrics.argocd.svc.cluster.local:8084'
    metadata:
      annotations:
        argocd.argoproj.io/sync-wave: "1"
    destination:
      namespace: monitoring
      server: https://kubernetes.default.svc
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true

  grafana:
    namespace: argocd
    project: default
    source:
      chart: grafana
      repoURL: https://grafana.github.io/helm-charts
      targetRevision: "8.*"
      helm:
        values: |
          adminUser: admin
          adminPassword: admin

          service:
            type: ClusterIP
            port: 80

          ingress:
            enabled: true
            ingressClassName: alb
            annotations:
              alb.ingress.kubernetes.io/scheme: internet-facing
              alb.ingress.kubernetes.io/target-type: ip
              alb.ingress.kubernetes.io/group.name: shared-alb
              alb.ingress.kubernetes.io/group.order: "6"
              alb.ingress.kubernetes.io/healthcheck-path: /monitoring/grafana/api/health
              alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
              alb.ingress.kubernetes.io/success-codes: "200"
            hosts:
              - ${panel_domain}
            path: /monitoring/grafana
            pathType: Prefix

          grafana.ini:
            server:
              root_url: http://${panel_domain}/monitoring/grafana
              serve_from_sub_path: true
            auth.anonymous:
              enabled: false

          datasources:
            datasources.yaml:
              apiVersion: 1
              datasources:
              - name: Prometheus
                type: prometheus
                url: http://prometheus-server.monitoring.svc.cluster.local/monitoring/prometheus
                access: proxy
                isDefault: true

          dashboardProviders:
            dashboardproviders.yaml:
              apiVersion: 1
              providers:
              - name: 'default'
                orgId: 1
                folder: ''
                type: file
                disableDeletion: false
                editable: true
                options:
                  path: /var/lib/grafana/dashboards/default
              - name: 'argocd'
                orgId: 1
                folder: 'ArgoCD'
                type: file
                disableDeletion: false
                editable: true
                options:
                  path: /var/lib/grafana/dashboards/argocd

          dashboards:
            default:
              kubernetes-cluster:
                gnetId: 7249
                revision: 1
                datasource: Prometheus
              node-exporter:
                gnetId: 1860
                revision: 37
                datasource: Prometheus
              pod-monitoring:
                gnetId: 6417
                revision: 1
                datasource: Prometheus
              argocd:
                gnetId: 14584
                revision: 1
                datasource: Prometheus
              argocd-notifications:
                gnetId: 19974
                revision: 1
                datasource: Prometheus
              argocd-operational:
                gnetId: 19993
                revision: 1
                datasource: Prometheus

          sidecar:
            dashboards:
              enabled: true
              label: grafana_dashboard
              labelValue: "1"
    metadata:
      annotations:
        argocd.argoproj.io/sync-wave: "2"
    destination:
      namespace: monitoring
      server: https://kubernetes.default.svc
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true

  pro-shop-app:
    namespace: argocd
    project: default
    source:
      repoURL: https://github.com/nhahub/NHA-274.git
      targetRevision: HEAD
      path: k8s
    metadata:
      annotations:
        argocd.argoproj.io/sync-wave: "0"
    destination:
      namespace: pro-shop
      server: https://kubernetes.default.svc
    syncPolicy:
      automated:
        prune: true
        selfHeal: true
      syncOptions:
        - CreateNamespace=true

  ingress-app:
    namespace: argocd
    project: default
    source:
      path: k8s/ingress
      repoURL: https://github.com/nhahub/NHA-274.git
      targetRevision: HEAD
      helm:
        values: |
          sslCertificateArn: ${sslCertificateArn}
          domain: ${users_domain}
    destination:
      namespace: pro-shop
      server: https://kubernetes.default.svc
    metadata:
      annotations:
        argocd.argoproj.io/sync-wave: "1"
    syncPolicy:
      automated:
        selfHeal: true
      syncOptions:
        - CreateNamespace=true
