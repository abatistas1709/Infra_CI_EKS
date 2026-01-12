# Aplicação de exemplo (Nginx)
resource "kubernetes_deployment" "example" {
  metadata { name = "nginx-example" }
  spec {
    replicas = 2
    selector { match_labels = { app = "nginx" } }
    template {
      metadata { labels = { app = "nginx" } }
      spec {
        container {
          image = "nginx:latest"
          name  = "nginx"
          port { container_port = 80 }
        }
      }
    }
  }
  # ISSO É VITAL: Impede o Terraform de tentar criar o app 
  # antes de existirem máquinas reais para recebê-lo.
  depends_on = [aws_eks_node_group.study_nodes]
}

# Serviço que expõe o Nginx para a Internet na porta 8000
resource "kubernetes_service" "example_lb" {
  metadata { name = "nginx-service" }
  spec {
    selector = { app = "nginx" }
    port {
      port        = 8000 # Porta que você acessa no navegador
      target_port = 80   # Porta que o Nginx ouve no container
    }
    type = "LoadBalancer"
  }
  # Importante: o LB só pode ser criado se os nós estiverem prontos
  # O Service depende do Deployment, que por sua vez já depende dos nós.
  depends_on = [kubernetes_deployment.example]
}