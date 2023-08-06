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

## STEP 1:

Before you can configure Terraform to use an S3 bucket as a backend, you need to create an S3 bucket to store the state file.

Create a directory and sub-directory
``` bash 
mkdir -p Terraform_Project/S3_Bucket
```
Create 4 files under this directory

1. credentials.tf

``` hcl 
terraform {
  required_providers {
    aws ={
        source  = "hashicorp/aws"
        version = "~>5.0"
    }

  }
}

provider "aws" {
    region = var.region
}
```
Save the file

2. Variables.tf
```hcl
variable "region" {
  default = "ap-south-1"
}

variable "bucket-Name" {
  default = "Terraform-s3-project"
}

variable "s3_folder" {
  default = "State-files"
}

variable "s3_file" {
  default = "ec2.tf"
}

```
Save the file
3. Bucket.tf
Bucket name should be globally unique other wise S3 bucket will not allow you to create the bucket.
```hcl
resource "aws_s3_bucket" "my_bucket1" {
    bucket = var.bucket-Name
    tags = {
        Name = var.bucket-Name
    }
}

resource "aws_s3_object" "Bucket_directory1" {
  bucket = aws_s3_bucket.my_bucket1.bucket
  key    = "${var.s3_folder}/${var.s3_file}"
}
```
Save the file

4. Backend.tf
Terraform will not allow user to use the variables inside the backend so we have to hardcode the all the values.
```hcl
terraform {
    backend "s3" {
        bucket = "Terraform-s3-project"
        key    = "State-files/ec2.tf"
        region = "ap-south-1"

    }   
}
```
Save the file

Now let's create S3 bucket and add .tfstate file to it

Run below command one by one:

When we run "terraform init", plugins required for the provider are automatically downloaded and saved locally to .terraform directory.

```bash
terraform init
```
The "terraform plan" command is used to create an execution plan.
```bash
terraform plan
```
The "terraform apply" command is used to apply the changes required to reach the desired state of
the configuration.

Terraform apply will also write data to the "terraform.tfstate file".

Once apply is completed, resources are immediately available.
```bash
terraform apply
```


