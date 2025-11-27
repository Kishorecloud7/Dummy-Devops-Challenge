# terraform/main.tf
resource "kubernetes_namespace" "devops_challenge" {
  metadata {
    name = "devops-challenge"
  }
}

resource "kubernetes_resource_quota" "devops_quota" {
  metadata {
    name      = "devops-challenge-quota"
    namespace = kubernetes_namespace.devops_challenge.metadata[0].name
  }

  spec {
    hard = {
      "limits.memory" = "512Mi"
    }
  }
}
