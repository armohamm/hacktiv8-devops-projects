resource "aws_vpc" "devops-hacktiv8-project-vpc" {
  cidr_block            = "${var.vpcCIDRblock}"
  instance_tenancy      = "${var.instanceTenancy}"
  enable_dns_hostnames  = "${var.dnsHostNames}"
  enable_dns_support    = "${var.dnsSupport}"
tags {
  Name = "devops-hacktiv8-project-vpc"
  }
}

# CREATE SUBNET
resource "aws_subnet" "devops-hactiv8-project-subnet" {
  vpc_id                  = "${aws_vpc.devops-hacktiv8-project-vpc.id}"
  cidr_block              = "${var.subnetCIDRblock}"
  map_public_ip_on_launch = "${var.mapPublicIP}"
  availability_zone       = "${var.availabilityZone}"
tags {
  Name = "devops-hacktiv8-project-subnet"
 }
}


#CREATE SECURITY GROUP
resource "aws_security_group" "devops-hacktiv8-sg" {
  vpc_id      = "${aws_vpc.devops-hacktiv8-project-vpc.id}"
  name        = "devops-hactiv8-project-sg"
  description = "devops-hactiv8-project-sg"

ingress {
  cidr_blocks = "${var.ingressCIDRblockPublic}"
  from_port   = 22
  to_port     = 22
  protocol    = "tcp"
 }
tags {
  Name = "devops-sg-test"
 }
}

# CREATE ACL (Access Network Control)
resource "aws_network_acl" "devops-hacktiv8-project-acl" {
  vpc_id      = "${aws_vpc.devops-hacktiv8-project-vpc.id}"
  subnet_ids  = ["${aws_subnet.devops-hactiv8-project-subnet.id}"] 
  
  #ALLOW INGRESS ACL
  ingress {
    protocol = "ALL"
    rule_no = 100
    action = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port = 1025
    to_port = 65535
    
  }
  #ALLOW EGRESS EPHERMAL PORT
  egress = {
    protocol = "ALL"
    rule_no = 100
    action = "allow"
    cidr_block = "${var.destinationCIDRblock}"
    from_port = 1025
    to_port = 65535
  }
tags {
  Name = "devops-hacktiv8-project-acl"
 }
}

#CREATE INTERNET GATEWAY
resource "aws_internet_gateway" "devops-hacktiv8-project-internetGateway" {
  vpc_id = "${aws_vpc.devops-hacktiv8-project-vpc.id}"
tags {
  Name = "devops-haktiv8-project-internetGateway"
 }
}
#CREATE ROUTE TABLE
resource "aws_route_table" "devops-hacktiv8-project-routeTable" {
  vpc_id = "${aws_vpc.devops-hacktiv8-project-vpc.id}"
tags {
  Name = "devops-hacktiv8-project-routeTable"
 }
}
#CREATE INTERNET ACCESS
resource "aws_route" "devops-hactiv8-project-internetAccess" {
  route_table_id = "${aws_route_table.devops-hacktiv8-project-routeTable.id}"
  destination_cidr_block = "${var.destinationCIDRblock}"
  gateway_id = "${aws_internet_gateway.devops-hacktiv8-project-internetGateway.id}"
}

#ASSOCIATE ROUTE TABLE W/ SUBNET
resource "aws_route_table_association" "devops-hacktiv8-project-association" {
  subnet_id = "${aws_subnet.devops-hactiv8-project-subnet.id}"
  route_table_id = "${aws_route_table.devops-hacktiv8-project-routeTable.id}"
}