workspace=test
plan:
	terraform fmt -recursive
	terraform init
	terraform plan -var-file=terraform.$(workspace).tfvars

tfinit:
	terraform fmt -recursive
	terraform init
	terraform validate

validate:
	terraform fmt -recursive
	terraform validate

upgrade:
	terraform fmt -recursive
	terraform init --upgrade
	terraform validate

planout:
	terraform plan -out=out.plan -var-file=terraform.$(workspace).tfvars

apply:
	terraform apply -var-file=terraform.$(workspace).tfvars

destroy:
	terraform destroy -var-file=terraform.$(workspace).tfvars

refresh:
	terraform refresh -var-file=terraform.$(workspace).tfvars

destroy_t:
	terraform destroy -target $(target)

workspace:
	terraform workspace list
	terraform workspace create $(workspace) 
	
infracost: planout
	infracost breakdown --path=out.plan