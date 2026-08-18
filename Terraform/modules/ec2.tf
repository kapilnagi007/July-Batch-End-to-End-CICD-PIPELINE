module "ec2_instance" {
  source = "terraform-aws-modules/ec2-instance/aws"

  name = "single-instance"

  instance_type = "t3.micro"
  key_name      = "user1"
  monitoring    = false
  subnet_id     = "subnet-0b28abdbd084a2b78"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}