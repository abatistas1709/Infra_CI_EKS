variable "region" {
  description = "Região da AWS onde os recursos serão criados"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "Nome do cluster EKS"
  type        = string
  default     = "study-cluster"
}

variable "instance_type" {
  description = "Tipo da instância para os nós do EKS e RDS (Elegível para Free Tier)"
  type        = string
  default     = "t3.micro" # Free tier para a instância EC2
}

variable "db_username" {
  description = "Usuário mestre do banco de dados"
  type        = string
  default     = "root"
}

variable "db_password" {
  description = "Senha do banco de dados"
  type        = string
  sensitive   = true # Oculta a senha nos logs do terminal
  default     = "rootroot"
}

variable "db_name" {
  description = "Nome do banco de dados inicial"
  type        = string
  default     = "root"
}