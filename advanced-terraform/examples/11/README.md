# Workflow Demo Commands

## Hello World!

```
cd 101
terraform test
```

## Terratest: Hello World!

```
cd 200/tests
go mod init helloterratest
go get github.com/gruntwork-io/terratest/modules/terraform
go get github.com/stretchr/testify/assert@v1.4.0
go test -v
```

## Terratest with AWS

```
cd aws
go mod init helloterratest
go get github.com/gruntwork-io/terratest/modules/http-helper
go get github.com/gruntwork-io/terratest/modules/ssh@v0.36.3
go get github.com/gruntwork-io/terratest/modules/terraform@v0.36.3
```