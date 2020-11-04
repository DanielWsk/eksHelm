resource "aws_vpc" "tf-vpc" {
  cidr_block       = var.cidr
  instance_tenancy = "default"

  tags = {
    Name = "tf-vpc"
    Environment = var.environment
  }
}

resource "aws_internet_gateway" "igw1" {
  vpc_id = aws_vpc.tf-vpc.id

  tags = {
    Name = "igw"
    Environment = var.environment
  }
}

resource "aws_eip" "elasticip" {
  depends_on = [aws_internet_gateway.igw1]
}

resource "aws_nat_gateway" "natgw" {
  allocation_id = aws_eip.elasticip.id
  subnet_id     = aws_subnet.publicsubnet[0].id

  depends_on    = [aws_internet_gateway.igw1]

  tags = {
    Name = "natgw"
    Environment = var.environment
  }
}

resource "aws_subnet" "publicsubnet" {
  count              = length(var.pubsubnetcidrs)

  vpc_id             = aws_vpc.tf-vpc.id
  cidr_block         = element(concat(var.pubsubnetcidrs, [""]), count.index)
  availability_zone  = element(concat(var.azs, [""]), count.index)

  tags = {
    Name = "public-subnet ${count.index+1}"
    Environment = var.environment
    "kubernetes.io/cluster/eksCluster" = "shared"
    "kubernetes.io/role/elb" = 1
  }
}

resource "aws_route_table" "pubroute" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw1.id
  }

  tags = {
    Name = "pubroute"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "rtapub" {
  count          = length(var.pubsubnetcidrs)

  subnet_id      = element(aws_subnet.publicsubnet.*.id, count.index)
  route_table_id = aws_route_table.pubroute.id
}

resource "aws_subnet" "privatesubnet" {
  count             = length(var.privsubnetcidrs)

  vpc_id            = aws_vpc.tf-vpc.id
  cidr_block        = element(concat(var.privsubnetcidrs, [""]), count.index)
  availability_zone = element(concat(var.azs, [""]), count.index)

  tags = {
    Name = "private-subnet ${count.index+1}"
    Environment = var.environment
    "kubernetes.io/cluster/eksCluster" = "shared"
    "kubernetes.io/role/internal-elb" = 1
  }
}

resource "aws_route_table" "privroute" {
  vpc_id = aws_vpc.tf-vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_nat_gateway.natgw.id
  }

  tags = {
    Name = "privroute"
    Environment = var.environment
  }
}

resource "aws_route_table_association" "rtapriv" {
  count          = length(var.pubsubnetcidrs)

  subnet_id      = element(aws_subnet.privatesubnet.*.id, count.index)
  route_table_id = aws_route_table.privroute.id
}

resource "aws_security_group" "security-group1" {
  name        = "allow_tls"
  description = "Allow TLS inbound traffic"
  vpc_id      = aws_vpc.tf-vpc.id

  ingress {
    description = "TLS from VPC"
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = [aws_vpc.tf-vpc.cidr_block]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name   = "allow_tls"
    Environment = var.environment
  }
}