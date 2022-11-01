resource "aws_s3_bucket" "main" {
  bucket        = "${var.project}-bucket"
  acl           = "private"
  force_destroy = true

}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls   = true
  block_public_policy = true
}

variable "project" {}
variable "environment" {}

output "s3_bucket_name" {
  value = [aws_s3_bucket.main.bucket_domain_name, aws_s3_bucket.main.id]
}