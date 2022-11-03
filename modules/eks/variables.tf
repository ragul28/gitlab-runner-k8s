variable "project" {}
variable "eks_vpc_id" {}
variable "eks_subnet_ids" {}
variable "eks_version" {}
variable "eks_endpoint_sg_id" {}

variable "node_count" {
  default = 2
}

variable "node_max_count" {}
variable "node_min_count" {}

variable "eks_instance_types" {
  default = ["t3.small"]
}

variable "disk_size" {
  default     = 30
  description = "(optional) Node disk size"
}
