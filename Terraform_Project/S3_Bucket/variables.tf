variable "region" {
  default = "ap-south-1"
}

variable "bucket-Name" {
  default = "terraform-s3-project"
}

variable "s3_folder" {
  default = "State-files"
}

variable "s3_file" {
  default = "ec2.tf"
}