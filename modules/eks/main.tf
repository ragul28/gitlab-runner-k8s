#EKS
resource "aws_eks_cluster" "master" {
  name     = "${var.project}-eks"
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

#System node
resource "aws_eks_node_group" "system" {
  cluster_name    = aws_eks_cluster.master.name
  node_group_name = "${var.project}-system"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.eks_subnet_ids

  instance_types = var.eks_instance_types
  capacity_type  = "ON_DEMAND"

  version = var.eks_version

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  labels = {
    "eks.amazonaws.com/mode" = "system"
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

#Worker nodes
resource "aws_eks_node_group" "worker" {
  cluster_name    = aws_eks_cluster.master.name
  node_group_name = "${var.project}-worker"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.eks_subnet_ids

  instance_types = var.eks_instance_types
  capacity_type  = "SPOT"

  version = var.eks_version

  scaling_config {
    desired_size = var.node_count
    max_size     = var.node_max_count
    min_size     = var.node_min_count
  }

  labels = {
    "eks.amazonaws.com/mode" = "builds"
  }

  taint {
    key    = "eks.amazonaws.com/nodepriority"
    value  = "spot"
    effect = "NO_SCHEDULE"
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

