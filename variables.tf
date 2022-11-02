variable "project" {}
variable "environment" {}
variable "profile" {}

variable "aws_region" {}

##VPC
variable "main_vpc_cidr_block" {
  default = "10.50.0.0/24"
}

variable "az_set" {
  default = ["us-east-1c"]
}

variable "private_subnets" {
  default = ["10.50.0.0/26", "10.50.0.64/26"]
}

variable "public_subnets" {
  default = ["10.50.0.128/26", "10.50.0.192/26"]
}

variable "enable_natgw" {}

##EKS
variable "node_count" {
  default = 1
}

variable "eks_instance_types" {
  default = ["t3a.medium"]
}

variable "eks_version" {}

## gitlab
variable "gitlab_url" {}