### EC2
resource "aws_instance" "amazonlx2" {
  count   = 1
  
  ami		              = data.aws_ami.rhel_8_5.id
  instance_type               = "t3.micro"
  subnet_id		      = var.vpc_public_subnets
  vpc_security_group_ids      = [var.security_group_1, var.security_group_2]
  associate_public_ip_address = var.vm_associate_public_ip_address
  key_name                    = aws_key_pair.key_pair.key_name
  user_data		      = file("aws-user-data.sh")  

  root_block_device {
    volume_size = 8
    delete_on_termination = true
  }
  
  iam_instance_profile = aws_iam_instance_profile.ec2_profile_jenkins_ansible.name

  tags = {
    project = "hello-world"
  }

  monitoring              = true
  disable_api_termination = false
  ebs_optimized           = true
}
