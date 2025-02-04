#This project will automate the process of provisioning an EC2 instance using Terraform, and the deployment will be triggered by a push to a GitHub repository.
provider "aws"{
    region = "us-east-1"
}
resource "aws_vpc" "my_vpc" {
  cidr_block = "10.0.0.0/16"
  enable_dns_support = true
  enable_dns_hostnames = true
}
resource "aws_subnet" "my_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "us-east-1a"  # Choose your preferred AZ
  map_public_ip_on_launch = true
}
resource "aws_instance" "my_ec2_instance" {
  ami           = "ami-0c02fb55956c7d316"  # Replace with the correct AMI ID
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.my_subnet.id  # Reference to the subnet created
  tags = {
    Name = "MyEC2Instance"
  }
  key_name = "my-key"  # Use your existing key pair
}
resource "aws_security_group" "my_security_group" {
  name_prefix = "my-sg"
  vpc_id      = aws_vpc.my_vpc.id

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
}
