terraform {
  required_version = ">= 1.5.0"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes" # Provider oficial para gerenciar recursos dentro do cluster
      version = "~> 2.23"
    }
  }
}

provider "aws" {
  region = var.region
}

# Configuração dinâmica: o Terraform usa o endpoint do EKS recém-criado
# e gera um token via AWS CLI para se autenticar no Kubernetes.
provider "kubernetes" {
  host                   = aws_eks_cluster.study.endpoint
  cluster_ca_certificate = base64decode(aws_eks_cluster.study.certificate_authority[0].data)
  exec {
    api_version = "client.authentication.k8s.io/v1beta1"
    args        = ["eks", "get-token", "--cluster-name", aws_eks_cluster.study.name]
    command     = "aws"
  }
}