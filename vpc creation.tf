 # Creating VPC,name, CIDR and Tags
resource "aws_vpc" "my_vpc" {
  cidr_block           = "10.0.0.0/16"

  tags = {
    Name = "my_vpc"
  }
}

 #2: Create a public subnet
resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = "true"
  availability_zone       = "ap-south-1b"

  tags = {
    Name = "public_subnet"
  }
}

 #3 : create a private subnet
resource "aws_subnet" "private_subnet" {
  vpc_id                  = aws_vpc.my_vpc.id
  cidr_block              = "10.0.2.0/24"
  map_public_ip_on_launch = "false"
  availability_zone       = "ap-south-1a"

  tags = {
    Name = "private_subnet"
  }
}

 #4 : create IGW
resource "aws_internet_gateway" "my_igw"{
    vpc_id = aws_vpc.my_vpc.id

    tags = {
        Name = "my_vpc_igw"
    }
}

 #5 : route Tables for public subnet
resource "aws_route_table" "public_rt"{
    vpc_id = aws_vpc.my_vpc.id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.my_igw.id
    }
    tags = {
    Name = "public_rt"
    }
}
 

 #7 : route table association public subnet 
resource "aws_route_table_association" "public_rt_association"{
    subnet_id = aws_subnet.public_subnet.id
    route_table_id = aws_route_table.public_rt.id
}