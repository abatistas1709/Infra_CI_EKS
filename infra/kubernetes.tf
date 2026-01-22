# Serviço que expõe a aplicação para a Internet na porta 8000
resource "kubernetes_service" "LoadBalancer" {
  metadata { name = "load-balancer-go-api" }
  spec {
    selector = { nome = "go" }
    port {
      port        = 8000 # Porta que você acessa no navegador
      target_port = 8000   # Porta que o Nginx ouve no container
    }
    type = "LoadBalancer"
  }
}