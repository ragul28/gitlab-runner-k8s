# output "config_map_aws_auth" {
#   value = module.aws-eks.config_map_aws_auth
# }

# output "kubeconfig" {
#   value = module.aws-eks.kubeconfig
# }


output "eks_cluster_name" {
  value = module.aws-eks.eks_cluster_name
}
