provider "aws" {
  region  = var.aws_region
  profile = var.aws_profile
}

#-------------VPC-----------

resource "aws_vpc" "j_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true

  tags = {
    Name = "j_vpc"
  }
}

output "vpc_addr" {
  value = aws_vpc.j_vpc.id
}

#internet gateway


resource "aws_internet_gateway" "j_igw" {
  vpc_id = aws_vpc.j_vpc.id

  tags = {
    Name = "j_igw"
  }
}

# Route tables

resource "aws_route_table" "j_public_rt" {
  vpc_id = aws_vpc.j_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.j_igw.id
  }

  tags = {
    Name = "j_public"
  }
}

/*
resource "aws_default_route_table" "j_private_rt" {
  default_route_table_id = aws_vpc.j_vpc.default_route_table_id

  tags = {
    Name = "j_private"
  }
}
*/
resource "aws_subnet" "j_public1_subnet" {
  vpc_id                  = aws_vpc.j_vpc.id
  cidr_block              = var.cidrs["public1"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "j_public1"
  }
}
/*
resource "aws_subnet" "j_public2_subnet" {
  vpc_id                  = aws_vpc.j_vpc.id
  cidr_block              = var.cidrs["public2"]
  map_public_ip_on_launch = true
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "j_public2"
  }
}

resource "aws_subnet" "j_private1_subnet" {
  vpc_id                  = aws_vpc.j_vpc.id
  cidr_block              = var.cidrs["private1"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "j_private1"
  }
}

resource "aws_subnet" "j_private2_subnet" {
  vpc_id                  = aws_vpc.j_vpc.id
  cidr_block              = var.cidrs["private2"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "j_private2"
  }
}

resource "aws_subnet" "j_rds1_subnet" {
  vpc_id                  = aws_vpc.j_vpc.id
  cidr_block              = var.cidrs["rds1"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[0]

  tags = {
    Name = "j_rds1"
  }
}

resource "aws_subnet" "j_rds2_subnet" {
  vpc_id                  = aws_vpc.j_vpc.id
  cidr_block              = var.cidrs["rds2"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[1]

  tags = {
    Name = "j_rds2"
  }
}

resource "aws_subnet" "j_rds3_subnet" {
  vpc_id                  = aws_vpc.j_vpc.id
  cidr_block              = var.cidrs["rds3"]
  map_public_ip_on_launch = false
  availability_zone       = data.aws_availability_zones.available.names[2]

  tags = {
    Name = "j_rds3"
  }
}
*/
# Subnet Associations

resource "aws_route_table_association" "j_public_assoc" {
  subnet_id      = aws_subnet.j_public1_subnet.id
  route_table_id = aws_route_table.j_public_rt.id
}
/*
resource "aws_route_table_association" "j_public2_assoc" {
  subnet_id      = aws_subnet.j_public2_subnet.id
  route_table_id = aws_route_table.j_public_rt.id
}

resource "aws_route_table_association" "j_private1_assoc" {
  subnet_id      = aws_subnet.j_private1_subnet.id
  route_table_id = aws_default_route_table.j_private_rt.id
}

resource "aws_route_table_association" "j_private2_assoc" {
  subnet_id      = aws_subnet.j_private2_subnet.id
  route_table_id = aws_default_route_table.j_private_rt.id
}

resource "aws_db_subnet_group" "j_rds_subnetgroup" {
  name = "j_rds_subnetgroup"

  subnet_ids = [aws_subnet.j_rds1_subnet.id,
    aws_subnet.j_rds2_subnet.id,
    aws_subnet.j_rds3_subnet.id,
  ]

  tags = {
    Name = "j_rds_sng"
  }
}
*/
#Security groups

resource "aws_security_group" "j_dev_sg" {
  name        = "j_dev_sg"
  description = "Used for access to the dev instance"
  vpc_id      = aws_vpc.j_vpc.id

  #SSH

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
}

  #HTTP

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}
/*
#Public Security group

resource "aws_security_group" "j_public_sg" {
  name        = "j_public_sg"
  description = "Used for public and private instances for load balancer access"
  vpc_id      = aws_vpc.j_vpc.id

  #HTTP 

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  #Outbound internet access

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#Private Security Group

resource "aws_security_group" "j_private_sg" {
  name        = "j_private_sg"
  description = "Used for private instances"
  vpc_id      = aws_vpc.j_vpc.id

  # Access from other security groups

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

#RDS Security Group
resource "aws_security_group" "j_rds_sg" {
  name        = "j_rds_sg"
  description = "Used for DB instances"
  vpc_id      = aws_vpc.j_vpc.id

  # SQL access from public/private security group

  ingress {
    from_port = 3306
    to_port   = 3306
    protocol  = "tcp"

    security_groups = [aws_security_group.j_dev_sg.id,
      aws_security_group.j_public_sg.id,
      aws_security_group.j_private_sg.id,
    ]
  }
}

#---------compute-----------

resource "aws_db_instance" "j_db" {
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7.22"
  instance_class         = var.db_instance_class
  name                   = var.dbname
  username               = var.dbuser
  password               = var.dbpassword
  db_subnet_group_name   = aws_db_subnet_group.j_rds_subnetgroup.name
  vpc_security_group_ids = [aws_security_group.j_rds_sg.id]
  skip_final_snapshot    = true
}
*/
#key pair

resource "aws_key_pair" "j_auth" {
  key_name   = var.key_name
  public_key = file(var.public_key_path)
}

#dev server

resource "aws_instance" "j_dev" {
  instance_type = var.dev_instance_type
  ami           = var.params.dev_ami

  tags = {
      Name = "j_dev"
  }

  key_name               = aws_key_pair.j_auth.id
  vpc_security_group_ids = [aws_security_group.j_dev_sg.id]
  subnet_id              = aws_subnet.j_public1_subnet.id
#  user_data		 = file("/home/ec2-user/terraform/bootstrap.sh")

}

