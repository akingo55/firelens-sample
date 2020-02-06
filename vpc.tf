resource "aws_vpc" "main" {
  cidr_block = "10.100.0.0/16"
}

resource "aws_subnet" "public_a" {
  cidr_block              = "10.100.10.0/24"
  availability_zone       = "ap-northeast-1a"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags {
    Name = "firelens_sample_public_a"
  }
}

resource "aws_subnet" "public_c" {
  cidr_block              = "10.100.20.0/24"
  availability_zone       = "ap-northeast-1c"
  vpc_id                  = aws_vpc.main.id
  map_public_ip_on_launch = true
  tags {
    Name = "firelens_sample_public_c"
  }
}

resource "aws_internet_gateway" "main" {
  vpc_id = aws_vpc.main.id
  tags {
    Name = "firelens_sample"
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.main.id
  }
  tags {
    Name = "firelens_sample_public"
  }

}

resource "aws_route_table_association" "public_a" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_a.id
}

resource "aws_route_table_association" "public_c" {
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public_c.id
}

resource "aws_security_group" "outbound_only" {
  name   = "firelens_sample_outbound_only"
  vpc_id = aws_vpc.main.id
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

