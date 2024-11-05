###################### Public Subnets ################
resource "aws_subnet" "qa_pub_1" {
  vpc_id                  = aws_vpc.qa.id
  cidr_block              = "10.40.10.0/24"
  availability_zone       = var.use2a
  map_public_ip_on_launch = true
  tags = {
    Name = "qa-pub-1"
  }
}

resource "aws_subnet" "qa_pub_2" {
  vpc_id                  = aws_vpc.qa.id
  cidr_block              = "10.40.20.0/24"
  availability_zone       = var.use2b
  map_public_ip_on_launch = true
  tags = {
    Name = "qa-pub-2"
  }
}

###################### Private Subnets ################

resource "aws_subnet" "qa_pri_1" {
  vpc_id            = aws_vpc.qa.id
  cidr_block        = "10.40.30.0/24"
  availability_zone = var.use2a

  tags = {
    Name = "qa-priv-1"
  }
}

resource "aws_subnet" "qa_pri_2" {
  vpc_id            = aws_vpc.qa.id
  cidr_block        = "10.40.40.0/24"
  availability_zone = var.use2b
  tags = {
    Name = "qa-priv-2"
  }
}