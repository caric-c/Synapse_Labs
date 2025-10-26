# show path : Synapse_Labs/terraform/modules/vpc/bastion.tf


data "aws_ssm_parameter" "bastion_ami" {
  count = var.enable_bastion ? 1 : 0
  name  = var.bastion_ami_ssm_parameter
}

resource "aws_instance" "bastion" {
  count         = var.enable_bastion ? 1 : 0
  ami           = data.aws_ssm_parameter.bastion_ami[0].value
  instance_type = var.bastion_instance_type
  subnet_id     = aws_subnet.public[0].id
  key_name      = var.key_name

  vpc_security_group_ids = [aws_security_group.bastion[0].id]

  tags = { Name = "bastion-host" }
}



# data "aws_ami" "ubuntu" {
#   most_recent = true
#   owners      = ["099720109477"] # Canonical

#   filter {
#     name   = "name"
#     values = ["ubuntu/images/hvm-ssd/ubuntu-20.04-amd64-server-*"]
#   }
# }
