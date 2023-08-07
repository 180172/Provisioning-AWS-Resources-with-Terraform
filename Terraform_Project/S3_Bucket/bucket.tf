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
