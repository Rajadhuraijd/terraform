resource "aws_vpc" "dev_vpc" {
  cidr_block = var.cidr

  tags = {
    Name = "${var.env}-vpc"
  }
}

resource "aws_subnet" "pubsubnet01" {
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = "10.0.0.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = true
    tags = {
      name = "${var.env}-pubsubnet01" 
    }
}

resource "aws_subnet" "privsubnet01" {
    vpc_id = aws_vpc.dev_vpc.id
    cidr_block = "10.0.1.0/24"
    availability_zone = "us-east-1a"
    map_public_ip_on_launch = false

    tags = {
      name = "${var.env}-privsubnet01" 
    }
}

resource "aws_internet_gateway" "igw01" {
  vpc_id = aws_vpc.dev_vpc.id

  tags = {
      name = "${var.env}-igw01" 
    }
}

resource "aws_route_table" "pubroute01" {
    vpc_id = aws_vpc.dev_vpc.id

    route {
      cidr_block ="0.0.0.0/0"
      gateway_id = aws_internet_gateway.igw01.id
    }
    
}

resource "aws_route_table" "privroute01" {
    vpc_id = aws_vpc.dev_vpc.id
    
}

resource "aws_route_table_association" "pubroute01_assoc" {
  subnet_id = aws_subnet.pubsubnet01.id
  route_table_id = aws_route_table.pubroute01.id
  
}

resource "aws_route_table_association" "privroute01_assoc" {
  subnet_id =aws_subnet.privsubnet01.id
  route_table_id = aws_route_table.privroute01.id
 }

 resource "aws_security_group" "sg01" {
  name = "${var.env}-sg01"
  vpc_id = aws_vpc.dev_vpc.id
  
  ingress {
    description = "webserver port 80"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "ssh port 22"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port = 0
    to_port = 0
    protocol = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }
  tags = {
    Name = "${var.env}-sg01"
  }
 }
