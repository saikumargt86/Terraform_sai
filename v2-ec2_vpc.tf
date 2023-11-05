provider "aws" {
    region = "ap-south-1"
}

resource "aws_instance" "instanve_reference" {
    ami="ami-0287a05f0ef0e9d9a"
    instance_type = "t2.micro"
    key_name = "Sai_aws_key_pair"
    vpc_security_group_ids = [aws_security_group.tr_ssh.id]
    subnet_id = aws_subnet.dpw-public_subent_01.id
    for_each = toset(["jenkins-master", "build-slave","ansible"])
    tags ={
      Name ="${each.key}"
    }
  
}

resource "aws_security_group" "tr_ssh" {
  name = "uisg-using-terraform"
  vpc_id = aws_vpc.dpw-vpc.id

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

resource "aws_vpc" "dpw-vpc" {
          cidr_block = "10.1.0.0/16"
          tags = {
           Name = "dpw-vpc"
        }
      }

resource "aws_subnet" "dpw-public_subent_01" {
    vpc_id = aws_vpc.dpw-vpc.id
    cidr_block = "10.1.1.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1a"
    tags = {
      Name = "dpw-public_subent_01"
    }
}

resource "aws_subnet" "dpw-public_subent_02" {
    vpc_id = aws_vpc.dpw-vpc.id
    cidr_block = "10.1.2.0/24"
    map_public_ip_on_launch = "true"
    availability_zone = "ap-south-1b"
    tags = {
      Name = "dpw-public_subent_02"
    }
}


resource "aws_internet_gateway" "dpw-igw" {
    vpc_id = aws_vpc.dpw-vpc.id
    tags = {
      Name = "dpw-igw"
    }
}

resource "aws_route_table" "dpw-public-rt" {
    vpc_id = aws_vpc.dpw-vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.dpw-igw.id
    }
    tags = {
      Name = "dpw-public-rt"
    }
}

resource "aws_route_table_association" "dpw-rta-public-subent-1" {
    subnet_id = aws_subnet.dpw-public_subent_01.id
    route_table_id = aws_route_table.dpw-public-rt.id
}

resource "aws_route_table_association" "dpw-rta-public-subent-2" {
    subnet_id = aws_subnet.dpw-public_subent_02.id
    route_table_id = aws_route_table.dpw-public-rt.id
}