variable "gitlab_url" {
  default = "https://gitlab.com"
}

variable "gitlab_reg_token_map" {}

variable "s3_bucket_name" {}
variable "aws_region" {}
variable "runner_concurrent_count" {}
variable "gitlab_runner_helm_version" {}