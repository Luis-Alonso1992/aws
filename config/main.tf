terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
  }
}

# Configure the AWS Provider
provider "aws" {
  region = "us-east-1"
}

terraform {
  backend "s3" {
    bucket         = "terraform-090163643451-us-east-1-an"
    key            = "aws/terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
    
    # Enable S3 Native State Locking (Terraform 1.10+)
    use_lockfile  = true 
  }
}

#Ubuntu VM
resource "aws_instance" "web" {
    ami = "ami-0b6d9d3d33ba97d99"
    instance_type =  "t2.micro"
    vpc_security_group_ids =  [aws_security_group.instance.id]

  user_data = <<-EOF
              #!/bin/bash
              echo "Hello, World" > index.html
              nohup busybox httpd -f -p 8080 &
              EOF

  user_data_replace_on_change = true

  tags = {
    Name = "teraform-example"
  }
}

resource "aws_security_group" "instance" {
  name = "terraform-example-instance"
  ingress {
    from_port   = var.server_port
    to_port     = var.server_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

}
}

variable "server_port" {
    description ="The port used for HTTP requests"
    type = number
    default = 8080
}