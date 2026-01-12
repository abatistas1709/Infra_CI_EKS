module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "~> 5.0"

  name = "eks-study-vpc"
  cidr = "10.0.0.0/16"

  # O EKS exige subnets em pelo menos 2 Zonas de Disponibilidade (AZs)
  azs             = ["us-east-1a", "us-east-1b"]
  public_subnets  = ["10.0.1.0/24", "10.0.2.0/24"]

  # AJUSTE AQUI: Permite que os nós recebam IP público para se comunicarem
  map_public_ip_on_launch = true

  # NAT Gateway custa caro (~$32/mês). Para economia no estudo, 
  # usamos apenas subnets públicas e desativamos o NAT.
  enable_nat_gateway = false
  enable_vpn_gateway = false

  # Tag essencial para que o Kubernetes saiba onde criar Load Balancers públicos
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
}