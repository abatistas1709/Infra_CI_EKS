# Aplicação
resource "kubernetes_deployment" "go-api" {
  metadata { name = "go-api" }
  spec {
    replicas = 3
    selector { match_labels = { app = "go" } }
    template {
      metadata { labels = { app = "go" } }
      spec {
        container {
          image = "abatistas/cursoci2:latest"
          name  = "go"
          port { container_port = 8000 }
        }
      }
    }
  }
  # ISSO É VITAL: Impede o Terraform de tentar criar o app 
  # antes de existirem máquinas reais para recebê-lo.
  depends_on = [aws_eks_node_group.study_nodes]
}

# Serviço que expõe a aplicação para a Internet na porta 8000
resource "kubernetes_service" "LoadBalancer" {
  metadata { name = "load-balancer-go-api" }
  spec {
    selector = { app = "go" }
    port {
      port        = 8000 # Porta que você acessa no navegador
      target_port = 8000   # Porta que o Nginx ouve no container
    }
    type = "LoadBalancer"
  }
  # Importante: o LB só pode ser criado se os nós estiverem prontos
  # O Service depende do Deployment, que por sua vez já depende dos nós.
  depends_on = [kubernetes_deployment.go-api]
}