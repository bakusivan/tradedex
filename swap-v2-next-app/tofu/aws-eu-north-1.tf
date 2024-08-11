terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-north-1"
}

# Define existing VPC
data "aws_vpc" "existing" {
  id = "vpc-0459a5eff2a97f170"
}

# Define existing subnets individually
data "aws_subnet" "subnet1" {
  id = "subnet-0eebea041f24e208e"
}

data "aws_subnet" "subnet2" {
  id = "subnet-0ef6aaeb90f110665"
}

data "aws_subnet" "subnet3" {
  id = "subnet-07f583c2bc5b6a16c"
}

# Reference the subnet IDs
locals {
  subnet_ids = [
    data.aws_subnet.subnet1.id,
    data.aws_subnet.subnet2.id,
    data.aws_subnet.subnet3.id
  ]
}

# Define existing security groups
data "aws_security_group" "default" {
  id = "sg-01bd1831a3218eab0"
}

data "aws_security_group" "app" {
  id = "sg-0032e7937119d4d4e"
}

# IAM Role for EKS Node Group
resource "aws_iam_role" "tofu-role" {
  name = "tofu-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Principal = {
          Service = "ec2.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      },
      {
        Effect = "Allow"
        Principal = {
          Service = "eks.amazonaws.com"
        }
        Action = "sts:AssumeRole"
      }
    ]
  })
}


resource "aws_iam_role_policy_attachment" "AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.tofu-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.tofu-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2FullAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2FullAccess"
  role       = aws_iam_role.tofu-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEC2ReadOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ReadOnlyAccess"
  role       = aws_iam_role.tofu-role.name
}

resource "aws_iam_role_policy_attachment" "AmazonEKSServicePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
  role       = aws_iam_role.tofu-role.name
}


# EKS Cluster
resource "aws_eks_cluster" "example" {
  name     = "my-eks-cluster"
  role_arn = aws_iam_role.tofu-role.arn  # Dynamically reference the created IAM role's ARN
  version  = "1.30"

  vpc_config {
    subnet_ids         = local.subnet_ids
    security_group_ids = [
      data.aws_security_group.default.id,
      data.aws_security_group.app.id
    ]
  }

  tags = {
    Name = "my-eks-cluster"
  }
}

# EKS Node Group
resource "aws_eks_node_group" "example" {
  cluster_name    = aws_eks_cluster.example.name
  node_group_name = "example-node-group"
  node_role_arn   = aws_iam_role.tofu-role.arn
  subnet_ids      = local.subnet_ids
  instance_types  = ["t3.2xlarge"]  # Specify instance types

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }

  ami_type = "AL2_x86_64"  # Amazon Linux 2 AMI for x86_64 architecture

  tags = {
    Name = "example-node-group"
  }
}

# Output EKS cluster details
output "cluster_name" {
  value = aws_eks_cluster.example.name
}

output "cluster_endpoint" {
  value = aws_eks_cluster.example.endpoint
}

output "cluster_id" {
  value = aws_eks_cluster.example.id
}

output "node_group_arn" {
  value = aws_eks_node_group.example.arn
}
