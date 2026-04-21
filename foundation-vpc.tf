Desired Outcome
************************************
A VPC with a CIDR block of 10.0.0.0/16.
One public subnet with a CIDR block of 10.0.0.0/24.
One private subnet with a CIDR block of 10.0.1.0/24.
One Internet Gateway.
One public route table with a route to the Internet Gateway, and the correct association between the public subnet and the public route table.
##########################
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.41.0"
    }
  }
}
##########################################
provider "aws" {
  region = "ap-south-1"
}
#######################################################
resource "aws_vpc" "own_vpc"{
    cidr_block= "10.0.0.0/16"
    tags    = {
        Name="Roopa-vpc"
    }
}

resource "aws_subnet" "own_subnet1" {
    vpc_id = aws_vpc.own_vpc.id
    cidr_block = "10.0.0.0/24"
    tags = {
      Name="public-subnet"
    }
  
}
resource "aws_subnet" "own_subnet2" {
    vpc_id = aws_vpc.own_vpc.id
    cidr_block = "10.0.1.0/24"
    tags = {
      Name="private-subnet"
    }
  
}

resource "aws_internet_gateway" "own_igw" {
    vpc_id = aws_vpc.own_vpc.id
    tags = {
      Name="Roopa-igw"
    }
  
}

resource "aws_route_table" "own_route" {
    vpc_id=aws_vpc.own_vpc.id
    route   {
        cidr_block= "0.0.0.0/0"
        gateway_id= aws_internet_gateway.own_igw.id
    }
    tags={
        Name="Roopa-route"
    }
  
}

resource "aws_route_table_association" "own_route_association" {
    subnet_id = aws_subnet.own_subnet1.id
    route_table_id = aws_route_table.own_route.id
  
}
