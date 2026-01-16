# outputs.tf na pasta raiz

output "kubeconfig_command" {
  description = "Comando para configurar o acesso ao cluster"
  value       = module.prod.kubeconfig_command
}

output "load_balancer_hostname" {
  description = "URL do Load Balancer (acesse na porta 8000)"
  value       = module.prod.load_balancer_hostname
}

output "rds_endpoint" {
  description = "Endpoint do PostgreSQL"
  value       = module.prod.rds_endpoint
}

output "rds_IP" {
  description = "IP do PostgreSQL"
  value       = module.prod.rds_IP
}