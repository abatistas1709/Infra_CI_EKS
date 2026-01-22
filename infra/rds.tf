# Firewall do Banco: Permite tráfego na porta 5432 vindo da VPC do EKS
resource "aws_security_group" "rds_sg" {
  name   = "eks-rds-sg"
  vpc_id = module.vpc.vpc_id

  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = module.vpc.public_subnets_cidr_blocks
  }
}

# Grupo de subnets: O RDS exige subnets em AZs diferentes para resiliência
resource "aws_db_subnet_group" "default" {
  name       = "main-rds-subnet-group"
  subnet_ids = module.vpc.public_subnets
}

# Instância PostgreSQL
resource "aws_db_instance" "postgres" {
  identifier           = "study-database"
  engine               = "postgres"
  engine_version       = "13.18"
  instance_class       = "db.${var.instance_type}"
  allocated_storage    = 20
  db_name              = var.db_name
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  publicly_accessible  = true # Permite conectar via DBeaver/pgAdmin do seu PC
  skip_final_snapshot  = true # Necessário para o 'terraform destroy' não falhar
}