s3bucket = "target-bucket"
s3tfkey = "key=bucket-key.tfstate"
fileprod = ../../prod/prod.tfvars
filecomm = ../../common.tfvars

all: plan

get:		verify-aws-env-vars
	AWS_PROFILE=${AWS_PROFILE} terraform get

init:		verify-aws-env-vars
	AWS_PROFILE=${AWS_PROFILE} terraform init -backend=true -backend-config="bucket=$(s3bucket)" -backend-config=$(s3tfkey) -backend-config="region=${AWS_DEFAULT_REGION}"

plan:		verify-aws-env-vars init
	AWS_PROFILE=${AWS_PROFILE} terraform plan -var-file=$(fileprod) -var-file=$(filecomm)

apply:		verify-aws-env-vars init
	AWS_PROFILE=${AWS_PROFILE} terraform apply -var-file=$(fileprod) -var-file=$(filecomm)

output:		verify-aws-env-vars
	AWS_PROFILE=${AWS_PROFILE} terraform output -json

destroy:	verify-aws-env-vars
	AWS_PROFILE=${AWS_PROFILE} terraform destroy -var-file=$(fileprod) -var-file=$(filecomm)

verify-aws-env-vars:
ifndef AWS_PROFILE
	$(error AWS_PROFILE is not defined. Make sure that you set your AWS profile.)
endif
ifndef AWS_DEFAULT_REGION
	$(error AWS_DEFAULT_REGION is not defined. Make sure that you set your AWS region.)
endif