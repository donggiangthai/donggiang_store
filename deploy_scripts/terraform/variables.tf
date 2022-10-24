# variable "ec2_key_pair" {
#   description = "Login key pair"
#   default     = "ThaiDG-ec2-key-pair"
# }

# variable "ec2_security_groups" {
#   description = "Security group for ec2. Name: public-traffic"
#   default     = "sg-0de8a2967eaadcc4e"
# }

variable "public_subnet_us_east_1a" {
  description = "Public subnet us-east-1a. Name: devops-subnet-public1-us-east-1a"
  default     = "subnet-061eba8e293d4e8de"
}

variable "instance_type" {
  description = "EC2 instance type"
  default     = "t2.micro"
}