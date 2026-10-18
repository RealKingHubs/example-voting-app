variable "aws_region" {
  description = "AWS region to build in"
  type        = string
  default     = "eu-north-1"
}

variable "cluster_name" {
  type    = string
  default = "voting-app-eks"
}

variable "kubernetes_version" {
  type    = string
  default = "1.35"
}

variable "allowed_cidrs" {
  description = "Who may reach the Kubernetes API from the internet (your IP only)"
  type        = list(string)
}

variable "node_instance_types" {
  type    = list(string)
  default = ["m7i-flex.large"]
}

variable "node_capacity_type" {
  description = "ON_DEMAND is safest on a restricted plan."
  type        = string
  default     = "ON_DEMAND"
}

variable "tags" {
  type = map(string)
  default = {
    Project = "devops-capstone"
    Owner   = "kingsley"
  }
}