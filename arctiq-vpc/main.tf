resource "aws_vpc" "arctiqvpc" {
  cidr_block       = var.cidr_block
  instance_tenancy = "default"

  enable_dns_hostnames = true
  enable_dns_support = true

  tags = {
    Name = "eks_vpc"
  }
}

resource "aws_security_group" "prodvpc-sg" {
  name        = "arctivpc-sg"
  description = "Opening required ports only"
  vpc_id      = aws_vpc.arctiqvpc.id

  dynamic "ingress" {
    iterator = port
    for_each = var.ingress_rules
    content {
        from_port        = port.value
        to_port          = port.value
        protocol         = "tcp"
        cidr_blocks      = ["0.0.0.0/0"]
    }
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
  }

  tags = {
    Name = "arctiqvpc-sg"
  }
}

# Create an Internet Gateway for public subnets
resource "aws_internet_gateway" "arctiq-igw" {
  vpc_id = aws_vpc.arctiqvpc.id
}

#Create public-subnets
resource "aws_subnet" "prodpublic" {
  vpc_id                  = aws_vpc.arctiqvpc.id
  count                   = length(var.public_subnet_cidrs)
  cidr_block              = element(var.public_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet_names[count.index]
    "kubernetes.io/role/elb" = "1"
    "kubernetes.io/cluster/eks-cloud" = "owned"
  }
}

# Create private subnets
resource "aws_subnet" "private_subnets" {
  vpc_id                  = aws_vpc.arctiqvpc.id
  count                   = length(var.private_subnet_cidrs)
  cidr_block              = element(var.private_subnet_cidrs, count.index)
  availability_zone       = element(var.azs, count.index)
  map_public_ip_on_launch = false

  tags = {
    Name = var.private_subnet_names[count.index]
    "kubernetes.io/role/internal-elb" = "1"
    "kubernetes.io/cluster/eks-cloud" = "owned"
  }
}

resource "aws_eip" "arctiq_eip" {
  vpc = true

}

resource "aws_nat_gateway" "arctiq_natgw" {
  subnet_id = aws_subnet.prodpublic[0].id
  allocation_id = aws_eip.arctiq_eip.id
}

resource "aws_route_table" "public_RT_prod" {
  vpc_id = aws_vpc.arctiqvpc.id

  depends_on = [ aws_subnet.prodpublic ]

  route {
    gateway_id = aws_internet_gateway.arctiq-igw.id
    cidr_block = "0.0.0.0/0"
  }

  tags = {
    Name = "public_RT_prod"
  }

}

resource "aws_route_table_association" "publicRTA" {
  count = 2
  subnet_id = aws_subnet.prodpublic[count.index].id
  route_table_id = aws_route_table.public_RT_prod.id
}

resource "aws_route_table" "private_RT_prod1" {
  vpc_id = aws_vpc.arctiqvpc.id

  depends_on = [ aws_subnet.private_subnets ]
  
  route {
    nat_gateway_id = aws_nat_gateway.arctiq_natgw.id
    cidr_block = "0.0.0.0/0"
  }
  
  tags = {
    Name = "Private_RT_prod1"
  }

}

resource "aws_route_table_association" "private_RTA" {
  count          = 2 
  subnet_id      = aws_subnet.private_subnets[count.index].id
  route_table_id = aws_route_table.private_RT_prod1.id
}