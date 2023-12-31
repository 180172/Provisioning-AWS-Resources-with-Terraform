# Provisioning AWS Resources with Terraform: EC2, S3, DynamoDB & State Management

Hello everyone In this Terraform project, our objective is to provision an AWS EC2 instance, an S3 bucket, and an AWS DynamoDB table in the AWS cloud infrastructure using Terraform. As part of our best practises,0 we will be storing our Terraform state file in the S3 bucket, which will serve as our backend for managing state information.


## Prerequsite 

- AWS account

- IAM user with S3 & EC2 full access

## Terraforn Installation

Install my-project with rpm

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

If you are using something other than Amazon Linux, you can refer to the below link to refer to the Installation process.

https://developer.hashicorp.com/terraform/tutorials/aws-get-started/install-cli

## STEP 1:

Before you can configure Terraform to use an S3 bucket as a backend, you need to create an S3 bucket to store the state file.

Create a directory and sub-directory
``` bash 
mkdir -p Terraform_Project/S3_Bucket
```
Create 3 files under this directory

#### provider.tf

* In Terraform, a provider.tf file is typically used to configure and define the provider you're using to manage your infrastructure. Providers are plugins that Terraform uses to interact with various cloud platforms, services, or systems.
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

#### variables.tf

* The variables.tf file contains all the required variables to create the S3-bucket. By using input variables, your Terraform configurations become more dynamic and reusable, allowing you to easily adjust settings and values without modifying the actual resource definitions. 
```hcl
# Region in which the bucket should get created
variable "region" {
  default = "ap-south-1"
}

# Name of the bucket
variable "bucket-Name" {
  default = "Terraform-s3-project"
}

# Sub folder name in the bucket
variable "s3_folder" {
  default = "State-files"
}

# tf.state file name

variable "s3_file" {
  default = "ec2.tf"
}

```

#### bucket.tf
* The bucket.tf file is the file that creates the S3-Bucket. The bucket name must be globally unique; otherwise, the S3 bucket creation will not be allowed.

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
Now let's create an S3 bucket.

Run the below commands one by one:

When we run "terraform init", plugins required for the provider are automatically downloaded and saved locally to the .terraform directory.

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

Now S3-Bucket is created. Now let's create an EC2 instance with a new security_group and a dynamodb table and store their .tfstate file in an S3-Bucket.

## STEP 2:

Create a directory and sub-directory
``` bash 
mkdir -p Terraform_Project/Remote_Resource
```
Create 3 files under this directory

#### provider.tf

```hcl 
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

#### variables.tf
```hcl
variable "region" {
  default = "ap-south-1"
}

# AMI ID
variable "ami_id" {
  default = "ami-0f99c1965355b1274"
}

# Instance type
variable "instance_type" {
  default = "t2.micro"
}

# TAG
variable "instance_name" {
  default = "EC2_INSTANCE_TERRAFORM"
}

# DynamoDB table name
variable "state_table_name" {
  default = "State_Locker"
}
```

#### ec2.tf

- The ec2.tf file contains all the keys and values required to create an EC2 instance.
```hcl
resource "aws_instance" "EC2" {
    ami = var.ami_id
    instance_type = var.instance_type
    tags = {
      name = var.instance_name
    }
}
```

#### security_group.tf

- The security_group.tf file contains the port number, protocol, ingress(Inbond) and egress(Outbond) details required to create an EC2 instance.
```hcl
resource "aws_security_group" "terfm_project" {
    name        = "ALLOW_SSH"


    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]
    }

    ingress {
        from_port   = 80
        to_port     = 80
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }

    egress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]  
  }
}

```

#### dynamodb.tf

* The dynamodb.tf file contains all the details required to create a dynamodb table....
```hcl
resource "aws_dynamodb_table" "my_state_table" {
    name = var.state_table_name
    billing_mode = "PAY_PER_REQUEST"
    hash_key = "LockID"
    attribute {
      name = "LockID"
      type = "S"

    }
    tags = {
       Name = var.state_table_name
    
  }

}
```

#### backend.tf

- This backend.tf file will move .tfstate files to the S3-Bucket. Terraform will not allow users to use the variables inside the backend, so we have to hardcode all the values.
```hcl
terraform {
    backend "s3" {
        bucket = "Terraform-s3-project"
        key    = "State-files/ec2.tf"
        region = "ap-south-1"
    }   
}
```

Run below command one by one:
```bash
terraform init
```
```bash
terraform plan
```
```bash
terraform apply
```

After the resource is successfully created, open the S3 bucket and confirm .tfstate file is stored or not.

From the image, I can confirm that the S3 bucket was successfully created.

If you want to inspect the .tfstate select the file and click on Open.


![SC](https://github.com/180172/Provisioning-AWS-Resources-with-Terraform-EC2-S3-DynamoDB-State-Management/assets/110009356/9e0cf5c5-052b-47e8-996b-dcd536d07a00)

