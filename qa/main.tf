# Create a VPC
resource "aws_vpc" "qa" {
  cidr_block = var.qa_vpc_cidr
  tags = {
    Name        = "qa-vpc"
    Environment = "qa"
  }
}


resource "aws_internet_gateway" "qa" {
  vpc_id = aws_vpc.qa.id

  tags = {
    Name = "qa-igw"
  }
}

resource "aws_nat_gateway" "qa" {
  allocation_id = aws_eip.natgw_eip.id
  subnet_id     = aws_subnet.qa_pub_1.id

  tags = {
    Name = "qa-ngw"
  }

  # To ensure proper ordering, it is recommended to add an explicit dependency
  # on the Internet Gateway for the VPC.
  depends_on = [aws_internet_gateway.qa]
}

resource "aws_eip" "natgw_eip" {
  domain     = "vpc"
  depends_on = [aws_internet_gateway.qa]
  tags = {
    Name = "ngw-eip"
  }
}

