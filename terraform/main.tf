# Use the default VPC and its default subnets
data "aws_vpc" "default" {
  default = true
}

data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }

  filter {
    name   = "default-for-az"
    values = ["true"]
  }
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = var.cluster_name
  cluster_version = var.kubernetes_version

  vpc_id      = data.aws_vpc.default.id
  subnet_ids  = data.aws_subnets.default.ids
  enable_irsa = false

  # Least privilege: only your IP can reach the API from outside.
  # Private access must stay on, so the nodes can still reach the control plane.
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.allowed_cidrs
  cluster_endpoint_private_access      = true

  # Gives the identity running Terraform admin rights inside the cluster
  enable_cluster_creator_admin_permissions = true

  # Cost savings for a learning cluster
  create_kms_key              = false
  cluster_encryption_config   = {}
  cluster_enabled_log_types   = []
  create_cloudwatch_log_group = false

  cluster_addons = {
    coredns    = {}
    kube-proxy = {}
    vpc-cni = {
      before_compute = true
    }
  }

  eks_managed_node_groups = {
    default = {
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = var.node_instance_types
      capacity_type  = var.node_capacity_type

      min_size     = 1
      max_size     = 3
      desired_size = 2

      use_custom_launch_template = false
      disk_size                  = 20

    }
  }
}