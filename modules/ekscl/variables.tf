variable "vpc_id" {
  description = "The VPC ID where the EKS cluster will be deployed"
}

variable "private_subnet_ids" {
  description = "List of private subnet IDs for the EKS cluster"
  type = list(string)
}

variable "cluster_role_arn" {
  description = "IAM role ARN for the EKS cluster"
}

variable "node_role_arn" {
  description = "IAM role ARN for the EKS node group"
}