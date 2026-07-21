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
    bucket         = "terraform-090163643451-us-east-1-an  "
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
  
}

