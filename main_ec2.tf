provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "Udacity_T2" {
  count = 4 # create four similar EC2 instances
  ami = "ami-090fa75af13c156b4"
  instance_type = "t2.micro"
  tags = {
    Name = "EC2 T2 Server ${count.index}"
  }
}

resource "aws_instance" "Udacity_M4" {
  count = 2 # create four similar EC2 instances
  ami = "ami-090fa75af13c156b4"
  instance_type = "m4.large"
  tags = {
    Name = "EC2 M4 Server ${count.index}"
  }
}