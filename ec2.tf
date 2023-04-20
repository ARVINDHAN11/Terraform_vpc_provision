#Creating security group for inbound and outbound controll
resource "aws_security_group" "sg" {
    description = "Allow limited inbound externalm traffic "
    vpc_id = "${aws_vpc.my_vpc.id}"
    name = "terraform_ec2_private_sg"
    
    ingress {
        protocol = "tcp"
        from_port = 22
        to_port = 22
        cidr_blocks = ["0.0.0.0/0"]
    }
    ingress {
        protocol = "tcp"
        from_port = 8080
        to_port = 8080
        cidr_blocks = ["0.0.0.0/0"]
    }
    
    ingress {
        protocol = "tcp"
        from_port = 443
        to_port = 443
        cidr_blocks = ["0.0.0.0/0"]
    }
    egress {
        protocol = -1
        from_port = 0
        to_port = 0
        cidr_blocks = ["0.0.0.0/0"]
    }
    tags = {
        Name = "sg"
    }
}


# Creating public instance
resource "aws_instance" "public_instance" {
    ami = "ami-0fdea1353c525c182"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = "${aws_subnet.public_subnet.id}"
    key_name = "awskey"
    count = 1
    associate_public_ip_address = true
    tags = {
        Name = "public_instance"
    }
}

#Creating EC2 in private subnet
resource "aws_instance" "private_instance" {
    ami = "ami-0fdea1353c525c182"
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.sg.id]
    subnet_id = "${aws_subnet.private_subnet.id}"
    key_name = "awskey"
    count = 1
    associate_public_ip_address = false
    tags = {
        Name = "private_instance"
    }
}