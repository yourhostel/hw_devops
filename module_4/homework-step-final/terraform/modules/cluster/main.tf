# terraform/modules/cluster/main.tf

# AWS Provider configuration
provider "aws" {
  region = var.region
}

# EKS Cluster configuration
resource "aws_eks_cluster" "eks_cluster" {
  name     = var.name
  role_arn = aws_iam_role.eks_cluster_role.arn

  vpc_config {
    security_group_ids = [aws_security_group.eks_security_group.id]
    subnet_ids         = var.subnets_ids
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_cluster_policy,
    aws_iam_role_policy_attachment.eks_vpc_resource_controller,
  ]

  tags = merge(
    var.tags,
    { Name = var.name }
  )
}

data "aws_eks_cluster_auth" "eks_auth" {
  name = aws_eks_cluster.eks_cluster.name
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "${var.prefix}_node_group"
  node_role_arn   = aws_iam_role.eks_node_role.arn
  subnet_ids      = var.subnets_ids

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  instance_types = ["t3.large"]

  labels = {
    "node-type" = "tests"
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks_worker_node_policy,
    aws_iam_role_policy_attachment.eks_cni_policy,
    aws_iam_role_policy_attachment.ecr_read_only,
  ]

  tags = merge(
    var.tags,
    { Name = "${var.name}-node-group" }
  )
}

# IAM Role for the EKS cluster
resource "aws_iam_role" "eks_cluster_role" {
  name = "${var.prefix}-eks-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "eks.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# Required to interact with AWS Route 53 Resolver DNS Firewall
resource "aws_iam_role_policy" "eks_route53_resolver_policy" {
  name = "${var.prefix}-eks-route53-resolver-policy"
  role = aws_iam_role.eks_cluster_role.id

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Action = [
          "route53resolver:ListFirewallRuleGroupAssociations",
          "route53resolver:ListFirewallRuleGroups",
          "route53resolver:ListFirewallRules"
        ],
        Resource = "*"
      }
    ]
  })
}

# Attach the EKS Cluster Policy to the role
resource "aws_iam_role_policy_attachment" "eks_cluster_policy" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

# Attach the EKS VPC Resource Controller policy to the role
resource "aws_iam_role_policy_attachment" "eks_vpc_resource_controller" {
  role       = aws_iam_role.eks_cluster_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
}

# IAM Role for EKS worker nodes
resource "aws_iam_role" "eks_node_role" {
  name = "${var.prefix}-eks-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "ec2.amazonaws.com"
        },
        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = var.tags
}

# Attach required policies to the worker node role
resource "aws_iam_role_policy_attachment" "eks_worker_node_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
}

resource "aws_iam_role_policy_attachment" "eks_cni_policy" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
}

resource "aws_iam_role_policy_attachment" "ecr_read_only" {
  role       = aws_iam_role.eks_node_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

# Security Group for the EKS cluster
resource "aws_security_group" "eks_security_group" {
  name        = "${var.prefix}-eks-sg"
  description = "Security group for all nodes in the EKS cluster"
  vpc_id      = var.vpc_id

  # Allow all outbound traffic
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(
    var.tags,
    { "Name" = "${var.prefix}-eks-security-group" }
  )
}

# Allow inbound SSH access from your local machine (optional)
resource "aws_security_group_rule" "allow_ssh" {
  type              = "ingress"
  from_port         = 22
  to_port           = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_security_group.id
  cidr_blocks       = ["91.225.123.2/32"]  # Update to your current external IP
}

# Allow inbound traffic to the worker nodes from the EKS control plane
resource "aws_security_group_rule" "eks_ingress_kubernetes_api" {
  type                   = "ingress"
  from_port              = 443
  to_port                = 443
  protocol               = "tcp"
  security_group_id      = aws_security_group.eks_security_group.id
  source_security_group_id = aws_security_group.eks_security_group.id  # Replace with the correct control plane SG
}

# Setting up access to API server via HTTP/S for testing
resource "aws_security_group_rule" "allow_http_https" {
  type              = "ingress"
  from_port         = 80
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.eks_security_group.id
  cidr_blocks       = ["0.0.0.0/0"]  # Be cautious with open access like this
}

# Outputs
output "eks_cluster_id" {
  description = "ID of the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.id
}

output "eks_node_group_id" {
  description = "ID of the EKS node group"
  value       = aws_eks_node_group.eks_node_group.id
}

output "eks_cluster_security_group_id" {
  description = "Security group ID for the EKS cluster"
  value       = aws_security_group.eks_security_group.id
}

output "eks_cluster_endpoint" {
  description = "Endpoint for the EKS cluster"
  value       = aws_eks_cluster.eks_cluster.endpoint
}

output "cluster_ca_certificate" {
  value = aws_eks_cluster.eks_cluster.certificate_authority[0].data
}

output "cluster_token" {
  value = data.aws_eks_cluster_auth.eks_auth.token
}
