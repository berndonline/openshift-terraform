# Create a VPC to launch our instances into
resource "aws_vpc" "default" {
    cidr_block = "${var.vpc_cidr}"
    enable_dns_support = true
    enable_dns_hostnames = true
    tags {
      Name = "VPC"
    }
}

resource "aws_subnet" "PublicSubnetA" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_a}"
  tags {
        Name = "Public Subnet A"
  }
 availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
resource "aws_subnet" "PublicSubnetB" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_b}"
  tags {
        Name = "Public Subnet B"
  }
 availability_zone = "${data.aws_availability_zones.available.names[1]}"
}
resource "aws_subnet" "PublicSubnetC" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.public_subnet_c}"
  tags {
        Name = "Public Subnet C"
  }
 availability_zone = "${data.aws_availability_zones.available.names[2]}"
}
resource "aws_subnet" "PrivateSubnetA" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_a}"
  tags {
        Name = "Private Subnet A"
  }
 availability_zone = "${data.aws_availability_zones.available.names[0]}"
}
resource "aws_subnet" "PrivateSubnetB" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_b}"
  tags {
        Name = "Private Subnet B"
  }
 availability_zone = "${data.aws_availability_zones.available.names[1]}"
}
resource "aws_subnet" "PrivateSubnetC" {
  vpc_id = "${aws_vpc.default.id}"
  cidr_block = "${var.private_subnet_c}"
  tags {
        Name = "Private Subnet C"
  }
 availability_zone = "${data.aws_availability_zones.available.names[2]}"
}

resource "aws_route_table_association" "PublicSubnetA" {
    subnet_id = "${aws_subnet.PublicSubnetA.id}"
    route_table_id = "${aws_route_table.public_route_a.id}"
}
resource "aws_route_table_association" "PublicSubnetB" {
    subnet_id = "${aws_subnet.PublicSubnetB.id}"
    route_table_id = "${aws_route_table.public_route_b.id}"
}
resource "aws_route_table_association" "PublicSubnetC" {
    subnet_id = "${aws_subnet.PublicSubnetC.id}"
    route_table_id = "${aws_route_table.public_route_c.id}"
}
resource "aws_route_table_association" "PrivateSubnetA" {
    subnet_id = "${aws_subnet.PrivateSubnetA.id}"
    route_table_id = "${aws_route_table.private_route_a.id}"
}
resource "aws_route_table_association" "PrivateSubnetB" {
    subnet_id = "${aws_subnet.PrivateSubnetB.id}"
    route_table_id = "${aws_route_table.private_route_b.id}"
}
resource "aws_route_table_association" "PrivateSubnetC" {
    subnet_id = "${aws_subnet.PrivateSubnetC.id}"
    route_table_id = "${aws_route_table.private_route_c.id}"
}

resource "aws_internet_gateway" "gw" {
   vpc_id = "${aws_vpc.default.id}"
    tags {
        Name = "Internet Gateway"
    }
}
resource "aws_eip" "natgw_a" {
    vpc      = true
}
resource "aws_eip" "natgw_b" {
    vpc      = true
}
resource "aws_eip" "natgw_c" {
    vpc      = true
}
resource "aws_nat_gateway" "public_nat_a" {
    allocation_id = "${aws_eip.natgw_a.id}"
    subnet_id = "${aws_subnet.PublicSubnetA.id}"
    depends_on = ["aws_internet_gateway.gw"]
}
resource "aws_nat_gateway" "public_nat_b" {
    allocation_id = "${aws_eip.natgw_b.id}"
    subnet_id = "${aws_subnet.PublicSubnetB.id}"
    depends_on = ["aws_internet_gateway.gw"]
}
resource "aws_nat_gateway" "public_nat_c" {
    allocation_id = "${aws_eip.natgw_c.id}"
    subnet_id = "${aws_subnet.PublicSubnetC.id}"
    depends_on = ["aws_internet_gateway.gw"]
}

resource "aws_network_acl" "all" {
   vpc_id = "${aws_vpc.default.id}"
    egress {
        protocol = "-1"
        rule_no = 2
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    ingress {
        protocol = "-1"
        rule_no = 1
        action = "allow"
        cidr_block =  "0.0.0.0/0"
        from_port = 0
        to_port = 0
    }
    tags {
        Name = "open acl"
    }
}

resource "aws_route_table" "public_route_a" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "Public Route A"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}
resource "aws_route_table" "public_route_b" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "Public Route B"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}
resource "aws_route_table" "public_route_c" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "Public Route C"
  }
  route {
        cidr_block = "0.0.0.0/0"
        gateway_id = "${aws_internet_gateway.gw.id}"
    }
}
resource "aws_route_table" "private_route_a" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "Private Route A"
  }
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.public_nat_a.id}"
  }
}
resource "aws_route_table" "private_route_b" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "Private Route B"
  }
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.public_nat_b.id}"
  }
}
resource "aws_route_table" "private_route_c" {
  vpc_id = "${aws_vpc.default.id}"
  tags {
      Name = "Private Route C"
  }
  route {
        cidr_block = "0.0.0.0/0"
        nat_gateway_id = "${aws_nat_gateway.public_nat_c.id}"
  }
}
