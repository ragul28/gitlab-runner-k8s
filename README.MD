# Gitlab Runner Terraform    

* EKS
* S3
* Gitlab-runner Helm

## Usage

* Make sure AWS credentials are config using aws cli.
* Fill with necessary variables in `tfvars` file.
* Estimate cost calculation using infracost.
```sh
make infracost
```
* Run the terraform to create aws stack using Make.
```sh
make plan
make auto_apply
```
* OR Using reguler terraform cli.
```
terraform init
terraform apply
```

* To append kubeconfig file default path
```
aws eks update-kubeconfig --name <CLUSTER_NAME>
```
