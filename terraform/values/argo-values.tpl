redis-ha:
  enabled: false

redis:
  enabled: true

controller:
  replicas: 2
  resources:
    requests:
      cpu: 500m
      memory: 1Gi
    limits:
      cpu: 1
      memory: 2Gi
  extraArgs:
    - --metrics-application-labels
    - name,project,namespace,dest_server,dest_namespace,health_status,operation,sync_status
  metrics:
    enabled: true
    service:
      portName: metrics
      port: 8082
      targetPort: 8082

server:
  service:
    type: ClusterIP
  ingress:
    enabled: true
    annotations:
      alb.ingress.kubernetes.io/scheme: internet-facing
      alb.ingress.kubernetes.io/target-type: ip
      alb.ingress.kubernetes.io/group.name: shared-alb
      alb.ingress.kubernetes.io/group.order: "10"
      alb.ingress.kubernetes.io/healthcheck-path: /argocd/
      alb.ingress.kubernetes.io/healthcheck-protocol: HTTP
      alb.ingress.kubernetes.io/success-codes: "200,301,302"
    ingressClassName: alb
    hostname: ${panel_domain}
    path: /argocd
    pathType: Prefix
    tls: false
  extraArgs:
    - --basehref=/argocd/
    - --rootpath=/argocd
  

  metrics:
    enabled: true
    service:
      portName: metrics
      port: 8083
      targetPort: 8083
  autoscaling:
    enabled: true
    minReplicas: 2

repoServer:
  autoscaling:
    enabled: true
    minReplicas: 2
  metrics:
    enabled: true
    service:
      portName: metrics
      port: 8084
      targetPort: 8084

applicationSet:
  replicas: 2

configs:
  secret:
    argocdServerAdminPassword: "$2a$10$MVBkBkAxErFWaBpXA4Ltz.Kiwhcz0CkNmVZZgZPa/03JpykN50BVO"
  params:
    server.insecure: "true"
    server.rootpath: /argocd
    server.basehref: /argocd/



  
