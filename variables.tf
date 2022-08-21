variable "aws_region" {
        default = "us-west-1"
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "example-vpc"
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = string
  default     = "10.0.101.0/24"
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["10.0.2.0/24"]
}

variable "security_group_2" {
  type        = string
  default     = "sg-0dbe1a9da396a647d"
}

variable "security_group_1" {
  type        = string
  default     = "sg-0dbe1a9da396a647d"
}

variable "security_group_3" {
  type        = string
  default     = "sg-06241cdcc585090bb"
}

variable "vm_associate_public_ip_address" {
  type        = bool
  description = "Associate a public IP address to the EC2 instance"
  default     = true
}
