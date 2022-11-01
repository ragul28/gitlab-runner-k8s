#EKS
resource "aws_eks_cluster" "master" {
  name     = var.project
  role_arn = aws_iam_role.eks_cluster.arn
  version  = var.eks_version

  vpc_config {

    subnet_ids              = var.eks_subnet_ids
    security_group_ids      = [var.eks_endpoint_sg_id]
    endpoint_private_access = true
    endpoint_public_access  = true
    public_access_cidrs = [
      "0.0.0.0/0"
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.eks-cluster-AmazonEKSVPCResourceController,
  ]
}

#Worker nodes
resource "aws_eks_node_group" "worker" {
  cluster_name    = aws_eks_cluster.master.name
  node_group_name = "${var.project}-nodes"
  node_role_arn   = aws_iam_role.node.arn
  instance_types  = var.eks_instance_types
  subnet_ids      = var.eks_subnet_ids

  version = var.eks_version

  scaling_config {
    desired_size = var.node_count
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

#Worker Spot nodes
resource "aws_eks_node_group" "spot" {
  cluster_name    = aws_eks_cluster.master.name
  node_group_name = "${var.project}-spot"
  node_role_arn   = aws_iam_role.node.arn
  instance_types  = var.eks_instance_types
  subnet_ids      = var.eks_subnet_ids

  version = var.eks_version

  scaling_config {
    desired_size = var.node_count
    max_size     = var.node_max_count
    min_size     = var.node_min_count
  }

  lifecycle {
    ignore_changes = [
      scaling_config[0].desired_size
    ]
  }

  depends_on = [
    aws_iam_role_policy_attachment.node-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.node-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.node-AmazonEC2ContainerRegistryReadOnly,
  ]
}

