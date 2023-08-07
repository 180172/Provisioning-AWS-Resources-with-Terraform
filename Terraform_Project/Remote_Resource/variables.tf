
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


variable "state_table_name" {
  default = "State_Locker"
}


