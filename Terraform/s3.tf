resource "aws_s3_bucket" "example" {
  bucket = "my-tf-test-bucket-qwertyuiosadfdghjh-qwrmke"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}