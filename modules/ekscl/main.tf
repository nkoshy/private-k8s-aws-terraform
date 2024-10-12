resource "aws_eks_cluster" "eks_cluster" {
  name     = "ctrl_cluster"
  role_arn = var.cluster_role_arn
  version = "1.27"
  
  vpc_config {
    subnet_ids = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = false
  }
}

resource "aws_eks_node_group" "eks_node_group" {
  cluster_name    = aws_eks_cluster.eks_cluster.name
  node_group_name = "eks-private-nodegroup"
  node_role_arn   = var.node_role_arn
  subnet_ids      = var.private_subnet_ids

  scaling_config {
    desired_size = 2
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t3.medium"]
  disk_size      = 50
  capacity_type  = "SPOT"
}

output "cluster_name" {
  value = aws_eks_cluster.eks_cluster.name
}