resource "aws_vpc" "data_vpc_main" {
  cidr_block = "10.0.0.0/23" # 512 IPs
  tags = {
    Name = "data-vpc"
  }
  enable_dns_hostnames = true
  enable_dns_support   = true
}

# Creating public subnet
resource "aws_subnet" "data_public_subnet" {
  vpc_id                  = aws_vpc.data_vpc_main.id
  cidr_block              = "10.0.0.0/27" #32 IPs
  map_public_ip_on_launch = true          # public subnet
  availability_zone       = "eu-west-1a"
  tags = {
    Name = "${var.project_name}-public-subnet-1a"
  }
}

resource "aws_subnet" "data_public_subnet_2" {
  vpc_id                  = aws_vpc.data_vpc_main.id
  cidr_block              = "10.0.0.32/27" #32 IPs
  map_public_ip_on_launch = true           # public subnet
  availability_zone       = "eu-west-1b"
  tags = {
    Name = "${var.project_name}-public-subnet-1b"
  }
}

# Creating private subnet
resource "aws_subnet" "data_private_subnet" {
  vpc_id                  = aws_vpc.data_vpc_main.id
  cidr_block              = "10.0.1.0/27" #32 IPs
  map_public_ip_on_launch = true          # private subnet
  availability_zone       = "eu-west-1a"
  tags = {
    Name = "${var.project_name}-private-subnet-1a"
  }
}


resource "aws_internet_gateway" "data_gateway" {
  vpc_id = aws_vpc.data_vpc_main.id
  tags = {
    Name = "${var.project_name}-data-gateway"
  }
}

# route table for public subnet - connecting to Internet gateway
resource "aws_route_table" "data_route_table_public" {
  vpc_id = aws_vpc.data_vpc_main.id
  tags = {
    Name = "${var.project_name}-public-RT"
  }

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.data_gateway.id
  }
}

# associate the route table with public subnet
resource "aws_route_table_association" "data_route_table_association" {
  subnet_id      = aws_subnet.data_public_subnet.id
  route_table_id = aws_route_table.data_route_table_public.id
}

resource "aws_route_table_association" "data_route_table_association_2" {
  subnet_id      = aws_subnet.data_public_subnet_2.id
  route_table_id = aws_route_table.data_route_table_public.id
}

resource "aws_eip" "eip" {
  depends_on = [aws_internet_gateway.data_gateway]
  vpc        = true
  tags = {
    Name = "data_EIP_for_NAT"
  }
}

# NAT gateway for private subnets
# (for the private subnet to access internet - in our case, downloading the external dataset)
resource "aws_nat_gateway" "data_nat_for_private_subnet" {
  allocation_id = aws_eip.eip.id
  subnet_id     = aws_subnet.data_public_subnet.id # nat should be in public subnet

  tags = {
    Name = "${var.project_name}-private-NAT"
  }

  depends_on = [aws_internet_gateway.data_gateway]
}

# route table - connecting to NAT
resource "aws_route_table" "data_rt_private" {
  vpc_id = aws_vpc.data_vpc_main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.data_nat_for_private_subnet.id
  }
    tags = {
    Name = "${var.project_name}-private-RT"
  }
}

# associate the route table with private subnet
resource "aws_route_table_association" "data_private_rta" {
  subnet_id      = aws_subnet.data_private_subnet.id
  route_table_id = aws_route_table.data_rt_private.id
}