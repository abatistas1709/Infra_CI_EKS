# IAM Role: Permite que o serviço EKS da AWS gerencie recursos em seu nome
resource "aws_iam_role" "cluster" {
  name = "eks-study-cluster-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17", Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "eks.amazonaws.com" } }]
  })
}

resource "aws_iam_role_policy_attachment" "cluster_policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

# Recurso do Cluster EKS
resource "aws_eks_cluster" "study" {
  name     = var.cluster_name
  role_arn = aws_iam_role.cluster.arn
  version  = "1.31"
  vpc_config { subnet_ids = module.vpc.public_subnets }
  depends_on = [aws_iam_role_policy_attachment.cluster_policy]
}

# IAM Role para os Nodes: Permite que as instâncias EC2 se conectem ao cluster
resource "aws_iam_role" "nodes" {
  name = "eks-study-node-role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17", Statement = [{ Action = "sts:AssumeRole", Effect = "Allow", Principal = { Service = "ec2.amazonaws.com" } }]
  })
}

# Anexa as políticas básicas para funcionamento dos nós, CNI e Registry
resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  ])
  policy_arn = each.value
  role       = aws_iam_role.nodes.name
}

# Node Group: Onde as máquinas (t3.micro) são realmente criadas
resource "aws_eks_node_group" "study_nodes" {
  cluster_name    = aws_eks_cluster.study.name
  node_group_name = "study-node-group"
  node_role_arn   = aws_iam_role.nodes.arn
  subnet_ids      = module.vpc.public_subnets
  instance_types  = [var.instance_type]

  scaling_config {
    desired_size = 2 # Rodar 2 máquinas para garantir que o LoadBalancer funcione bem
    max_size     = 2
    min_size     = 1
  }

  depends_on = [aws_iam_role_policy_attachment.node_policies]
}