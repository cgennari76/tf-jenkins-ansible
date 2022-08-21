# Get latest Amazon Linux 2 AMI
data "aws_ami" "amazon-linux-2" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-hvm-*-x86_64-ebs"]
  }
}

data "aws_ami" "rhel_8_5" {
  most_recent = true
  owners      = ["309956199498"] // Red Hat's Account ID  
  
  filter {
    name   = "name"
    values = ["RHEL-8.5*"]
  }  
  filter {
    name   = "architecture"
    values = ["x86_64"]
  }  
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }  
  
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
