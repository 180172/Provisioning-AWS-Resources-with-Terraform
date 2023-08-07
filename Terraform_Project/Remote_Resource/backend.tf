terraform {
    backend "s3" {
        bucket = "terraform-s3-project"
        key    = "State-files/ec2.tf"
        region = "ap-south-1"

    }   
}
