terraform{
    required_providers {
        aws={
            source="hashicorp/aws"
            version="~>5.0"
        }
    }

    backend "s3"{
        bucket="sandesh-terraform-bucket"
        key="state"
        workspace_key_prefix="dtc"
        region="us-east-1"
        access_key=var.aws_access_key
        secret_key=var.aws_secret_key

    }

}

provider "aws"{
    region= "us-east-1"
    access_key=var.aws_access_key
    secret_key=var.aws_secret_key
}

resource "aws_vpc" "dtc_vpc"{
    cidr_block= var.vpc_cidr
    enable_dns_hostnames= true
    tags={
        Name="dtc-vpc"
    }
}

resource "aws_subnet" "dtc_public_subnet"{
    count= length(var.zone)
    depends_on= [aws_vpc.dtc_vpc]
    vpc_id= aws_vpc.dtc_vpc.id
    availability_zone= element(var.zone, count.index)
    cidr_block= element(var.public_cidr, count.index)
    map_public_ip_on_launch= true
    tags= {Name="dtc-public-subnet ${count.index+1}"}      
}

resource "aws_subnet" "dtc_private_subnet"{
    count= length(var.zone)
    depends_on= [aws_vpc.dtc_vpc]
    vpc_id= aws_vpc.dtc_vpc.id
    availability_zone= element(var.zone, count.index)
    cidr_block= element(var.private_cidr, count.index)
    map_public_ip_on_launch= false
    tags= {Name="dtc-private-subnet ${count.index+1}"}      
}

resource "aws_internet_gateway" "dtc_igw"{
    vpc_id= aws_vpc.dtc_vpc.id
    tags={Name="dtc-internet-gateway"}
    depends_on=[aws_vpc.dtc_vpc, aws_subnet.dtc_public_subnet, aws_subnet.dtc_private_subnet]
}

resource "aws_eip" "nat_ip"{
    vpc= true
}

resource "aws_nat_gateway" "dtc_ngw"{
    depends_on= [aws_internet_gateway.dtc_igw]
    allocation_id= aws_eip.nat_ip.id
    subnet_id= aws_subnet.dtc_public_subnet[0].id
    tags={
        Name="dtc-nat-gateway"
    }
}

resource "aws_route_table" "dtc_public_routes"{
    vpc_id= aws_vpc.dtc_vpc.id
    route{
        cidr_block= "0.0.0.0/0"
        gateway_id= aws_internet_gateway.dtc_igw.id
    }

    tags= {Name="dtc-public-route-table"}
}

resource "aws_route_table" "dtc_private_routes"{
    vpc_id= aws_vpc.dtc_vpc.id
    route{
        cidr_block= "0.0.0.0/0"
        gateway_id= aws_nat_gateway.dtc_ngw.id
    }

    tags= {Name="dtc-private-route-table"}
}

resource "aws_route_table_association" "pub"{
    count= length(aws_subnet.dtc_public_subnet)
    route_table_id= aws_route_table.dtc_public_routes.id
    subnet_id= aws_subnet.dtc_public_subnet[count.index].id
}

resource "aws_route_table_association" "priv"{
    count= length(aws_subnet.dtc_private_subnet)
    route_table_id= aws_route_table.dtc_private_routes.id
    subnet_id= aws_subnet.dtc_private_subnet[count.index].id
}