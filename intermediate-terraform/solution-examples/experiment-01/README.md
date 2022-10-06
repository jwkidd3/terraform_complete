# How to Run?

```
terraform workspace new dev
terraform init -backend-config=./backend.tfvars -backend-config=bucket=terraform-di-[student-alias]
terraform apply
```