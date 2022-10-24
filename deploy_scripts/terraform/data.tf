locals {
  common_tags = {
    Purpose = "DevOps"
  }
}

data "aws_ami_ids" "amazon_ami_free_tier" {
  owners = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-kernel*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "block-device-mapping.volume-type"
    values = ["gp2"]
  }

  filter {
    name   = "image-type"
    values = ["machine"]
  }

  filter {
    name   = "state"
    values = ["available"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

data "aws_key_pair" "devops_key" {
  include_public_key = true

  filter {
    name   = "tag:Purpose"
    values = ["DevOps"]
  }
}

data "aws_launch_template" "devops_launch_template" {
  filter {
    name   = "tag:Purpose"
    values = ["DevOps"]
  }
}

data "aws_vpcs" "devops_vpc" {
  filter {
    name   = "tag:Purpose"
    values = ["DevOps"]
  }
}

data "aws_subnets" "public_subnet_us_east_1a" {
  filter {
    name   = "tag:Name"
    values = ["devops-subnet-public1-us-east-1a"]
  }
}

data "aws_security_groups" "devops_public_sg" {
  tags = {
    Name    = "devops-public-sg"
    Purpose = "DevOps"
  }
}


# Because the old image can not use any more so we only have the first item to use
output "ami_id" {
  value = data.aws_ami_ids.amazon_ami_free_tier.ids[0]
}

output "key_pair_name" {
  value = data.aws_key_pair.devops_key.key_name
}

output "launch_template_name" {
  value = data.aws_launch_template.devops_launch_template.name
}

output "vpc_id" {
  value = data.aws_security_groups.devops_public_sg.vpc_ids[0]
}

output "public_subnet_use1a_id" {
  value = data.aws_subnets.public_subnet_us_east_1a.ids[0]
}

output "devops_public_sg" {
  value = data.aws_security_groups.devops_public_sg.ids[0]
}
