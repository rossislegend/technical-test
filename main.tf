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

    ingress {
        description      = "SSH for admin"
        from_port        = 22
        to_port          = 22
        protocol         = "tcp"
        cidr_blocks      = ["94.2.240.153/32"]
    }

    ingress {
        description      = "HTTP for public"
        from_port        = 80
        to_port          = 80
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }

    egress {
        from_port        = 0
        to_port          = 0
        protocol         = "-1"
        cidr_blocks      = ["0.0.0.0/0"]
        ipv6_cidr_blocks = ["::/0"]
    }
}

resource "aws_instance" "ec2-instance1" {
    ami = "ami-0194c3e07668a7e36"
    key_name = "EC2_Instance"
    vpc_security_group_ids = [aws_security_group.ec2a38c443.id]
    instance_type = "t2.micro"

    tags = {
        Name = "EC2_Instance1"
    }

    ebs_optimized = false
    iam_instance_profile = "EC2-read-s3"
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

  lifecycle {
      create_before_destroy = true
  }
}

resource "aws_instance" "ec2-instance2" {
    ami = "ami-0194c3e07668a7e36"
    key_name = "EC2_Instance"
    vpc_security_group_ids = [aws_security_group.ec2a38c443.id]
    instance_type = "t2.micro"

    tags = {
        Name = "EC2_Instance2"
    }

    ebs_optimized = false
    iam_instance_profile = "EC2-read-s3"
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

  lifecycle {
      create_before_destroy = true
  }
}