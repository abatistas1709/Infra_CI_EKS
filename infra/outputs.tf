# Comando para você rodar no seu PC e conseguir usar 'kubectl get nodes'
output "kubeconfig_command" {
  description = "Comando para configurar o acesso ao cluster"
  value       = "aws eks update-kubeconfig --region us-east-1 --name ${aws_eks_cluster.study.name}"
}

# URL pública para acessar seu site/app
output "load_balancer_hostname" {
  description = "URL do Load Balancer (acesse na porta 8000)"
  value       = kubernetes_service.example_lb.status[0].load_balancer[0].ingress[0].hostname
}

# Endpoint do Banco de Dados
output "rds_endpoint" {
  description = "Endpoint do PostgreSQL"
  value       = aws_db_instance.postgres.endpoint
}

# IP do Banco de Dados
output "rds_IP" {
  description = "IP do PostgreSQL"
  value       = aws_db_instance.postgres.address
}