# resource "aws_instance" "devops_instance" {
#   ami                    = data.aws_ami_ids.amazon_ami_free_tier.ids[0]
#   subnet_id              = data.aws_subnets.public_subnet_us_east_1a.ids[0]
#   instance_type          = var.instance_type
#   key_name               = data.aws_key_pair.devops_key.key_name
#   vpc_security_group_ids = [data.aws_security_groups.devops_public_sg.ids[0], ]
#   user_data              = file("templates/install.sh")
#   tags                   = local.common_tags
# }

# output "instance_id" {
#   value = aws_instance.devops_instance.id
# }

resource "aws_instance" "test_instance" {
  ami                         = data.aws_ami_ids.amazon_ami_free_tier.ids[0]
  instance_type               = var.instance_type
  key_name                    = data.aws_key_pair.devops_key.key_name
  subnet_id                   = data.aws_subnets.public_subnet_us_east_1a.ids[0]
  associate_public_ip_address = true
  vpc_security_group_ids      = [data.aws_security_groups.devops_public_sg.ids[0], ]
  hibernation                 = true
  user_data                   = file("templates/amazon_linux2_install.sh")
  # root device volume
  root_block_device {
    encrypted = true
  }
  # tags
  tags = (merge(
    local.common_tags,
    tomap({
      "name" = "test-instance"
    })
  ))
}
