terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

provider "aws" {
    region = "eu-west-2"
}

resource "aws_security_group" "ec2a38c443" {
    description = "Security Group for EC2 Instances"
    name = "ec2_instance_sg"
    vpc_id = "vpc-9d9fabf5"
}

resource "aws_instance" "ec280e0f23" {
    ami = "ami-0194c3e07668a7e36"
    key_name = "EC2_Instance"
    vpc_security_group_ids = [
        "sg-01903965eec6f33bf"
    ]
    instance_type = "t2.micro"
    tenancy = "default"
    monitoring = false
    disable_api_termination = false
    instance_initiated_shutdown_behavior = "stop"
    credit_specification {
        cpu_credits = "standard"
    }

    tags {
        Name = "EC2_instance"
    }

    ebs_optimized = false
    iam_instance_profile = "arn:aws:iam::859110110592:instance-profile/EC2-read-s3"
    root_block_device {
        volume_type = "gp2"
        volume_size = 8
    }

    user_data = <<EOF
#!/bin/bash
sudo apt update
sudo apt upgrade -y

sudo apt install -y awscli
sudo apt install -y nginx

aws s3 cp s3://html-s3bucket/index.html index.html
sudo mv ./index.html /var/www/html/index.html

sudo systemctl restart nginx
EOF
}