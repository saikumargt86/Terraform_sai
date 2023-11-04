provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "instanve_reference" {
    ami="ami-0a6ed6689998f32a5"
    instance_type = "t2.micro"
    key_name = "Sai_aws_key_pair"
    security_groups = ["sg-using-terraform"]
  
}

resource "aws_security_group" "tr_ssh" {
  name = "uisg-using-terraform"

  #Incoming traffic or inbound rules
  ingress {
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"] #replace it with your ip address
  }

  #Outgoing traffic or out bound rules
  egress { 
    from_port = 0
    protocol = "-1"
    to_port = 0
    cidr_blocks = ["0.0.0.0/0"]
  }
}

