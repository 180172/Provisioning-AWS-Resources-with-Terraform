# Provisioning AWS Resources with Terraform: EC2, S3, DynamoDB & State Management

Hello everyone In this Terraform project, our objective is to provision an AWS EC2 instance, an S3 bucket, and an AWS DynamoDB table in the AWS cloud infrastructure using Terraform. As part of our best practices, we will be storing our Terraform state file in the S3 bucket, which will serve as our backend for managing state information.


## Prerequsite 

- AWS account

- IAM user with S3 & EC2 full access

## Terraforn Installation

Install my-project with npm

#### For Amazon Linux:

Install yum-config-manager to manage your repositories.
```bash
sudo yum install -y yum-utils
```
Use yum-config-manager to add the official HashiCorp Linux repository.
```bash
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/AmazonLinux/hashicorp.repo
```
Install Terraform from the new repository.
```bash
sudo yum -y install terraform
```
Verify that the terraform is insalled
```bash
sudo terraform --version
```

If you are using other than AmazonLinux you can refer the below link to refer Installation process

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli
