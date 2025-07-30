provider "aws"{
    region = "us-east-1"
}

data "aws_ami" "ubuntu"{
    most_recent      = true
    filter{
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
    }
    owners = ["099720109477"] # Canonical
}

data "aws_vpc" "default"{
    default =true
}
data "aws_subnet" "default"{
    availability_zone = "us-east-1a"
    filter {
        name = "vpc-id"
        values = [data.aws_vpc.default.id]
    }
}

resource "aws_security_group" "dtc_sg" {
   name        = "dtc_sg"
  description = "Allow TLS inbound traffic and all outbound traffic"
  vpc_id      = data.aws_vpc.default.id

  ingress{
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

}
resource "aws_instance" "dtc_instance"{
    ami          =  data.aws_ami.ubuntu.id
    instance_type = "t2.micro"
    key_name = "dtc_jul29"
    associate_public_ip_address = true
    subnet_id= data.aws_subnet.default.id
    vpc_security_group_ids = [aws_security_group.dtc_sg.id]
    depends_on = [aws_security_group.dtc_sg]
    tags = {
        Name = "DTCInstance"
    }
}

output  "instance_id" {
    description = "The ID of the instance"
    value =aws_instance.dtc_instance.id 
}

output  "public_ip" {
    description = "The ID of the instance"
    value = aws_instance.dtc_instance.public_ip
}

output  "ssh_description" {
    description = "The ID of the instance"
    value = "ssh -i dtc_jul29.pem ubuntu@${aws_instance.dtc_instance.public_ip}"
}