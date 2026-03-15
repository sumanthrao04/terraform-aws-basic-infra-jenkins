variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
}

variable "public_subnet_cidr" {
  description = "CIDR block for the public subnet"
  type        = string
}

variable "availability_zone" {
  description = "Availability zone for the public subnet"
  type        = string
  default     = "us-east-1a"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string

  validation {
    condition     = contains(["t3.micro", "t3.small"], var.instance_type)
    error_message = "Only t3.micro or t3.small are allowed for this project."
  }
}

variable "ami_id" {
  description = "AMI ID for EC2 instance"
  type        = string
}