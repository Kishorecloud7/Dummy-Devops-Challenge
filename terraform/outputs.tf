output "namespace" {
  value = kubernetes_namespace.devops_challenge.metadata[0].name
}
