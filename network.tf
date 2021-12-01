#----------EC2 Network--------------------
resource "aws_vpc" "wordpress_a" {
    cidr_block = var.vpc_a_cidr
    assign_generated_ipv6_cidr_block = false
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "VPC-A"
    }    
}
resource "aws_vpc" "wordpress_b" {
    cidr_block = var.vpc_b_cidr
    assign_generated_ipv6_cidr_block = false
    enable_dns_support = true
    enable_dns_hostnames = true
    tags = {
        Name = "VPC-B"
    }    
}
resource "aws_subnet" "wordpress_a" {
    vpc_id = aws_vpc.wordpress_a.id
    cidr_block = var.sbnt_a_cidr
    availability_zone = var.zone_a
    tags = {
      "Name" = "Subnet for WP in VPC-A"
    }
    map_public_ip_on_launch = true
}
resource "aws_subnet" "wordpress_b" {
    vpc_id = aws_vpc.wordpress_b.id
    cidr_block = var.sbnt_b_cidr
    availability_zone = var.zone_b
    tags = {
      "Name" = "Subnet for WP in VPC-B"
    }
    map_public_ip_on_launch = true
}
resource "aws_internet_gateway" "igw-a" {
    vpc_id = aws_vpc.wordpress_a.id
    tags = {
      "Name" = "igw-a"
    }
}
resource "aws_internet_gateway" "igw-b" {
    vpc_id = aws_vpc.wordpress_b.id
    tags = {
      "Name" = "igw-b"
    }
}
resource "aws_vpc_peering_connection" "peering_a-b" {    
    peer_vpc_id = aws_vpc.wordpress_a.id
    vpc_id = aws_vpc.wordpress_b.id
    auto_accept = true
    tags = {
      "Name" = "VPC Peering between A and B"
    }
}
resource "aws_default_route_table" "rt-a" {
    default_route_table_id = aws_vpc.wordpress_a.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-a.id
    }
    route {
        cidr_block = var.vpc_b_cidr
        gateway_id = aws_vpc_peering_connection.peering_a-b.id
    }
    route  {
        cidr_block = var.vpc_db_cidr
        gateway_id = aws_vpc_peering_connection.peering-a-db.id
    }
    tags = {
        Name = "rt-a public"
    }
}
resource "aws_default_route_table" "rt-b" {
    default_route_table_id = aws_vpc.wordpress_b.default_route_table_id
    route {
        cidr_block = "0.0.0.0/0"
        gateway_id = aws_internet_gateway.igw-b.id
    }
    route {
        cidr_block = var.vpc_a_cidr
        gateway_id = aws_vpc_peering_connection.peering_a-b.id
    }
    route  {
        cidr_block = var.vpc_db_cidr
        gateway_id = aws_vpc_peering_connection.peering-b-db.id
    }
    tags = {
        Name = "rt-b public"
    }
}
#----------EC2 Network--------------------

#----------RDS Network--------------------
resource "aws_vpc" "mysql-db-vpc" {
    cidr_block = var.vpc_db_cidr
    assign_generated_ipv6_cidr_block = false
    enable_dns_support = true
    tags = {
        Name = "VPC-DB"
    }    
}
resource "aws_subnet" "mysql-db-subnet-a" {
    vpc_id = aws_vpc.mysql-db-vpc.id
    cidr_block = var.sbnt_db-a_cidr
    availability_zone = var.zone_a
    tags = {
      "Name" = "Subnet for DB in A AZ"
    }
    map_public_ip_on_launch = false
}
resource "aws_subnet" "mysql-db-subnet-b" {
    vpc_id = aws_vpc.mysql-db-vpc.id
    cidr_block = var.sbnt_db-b_cidr
    availability_zone = var.zone_b
    tags = {
      "Name" = "Subnet for DB in B AZ"
    }
    map_public_ip_on_launch = false    
}
resource "aws_db_subnet_group" "mysql-db-subnet-group" {
    name = "mysql-db-subnet-group"
    subnet_ids = [ aws_subnet.mysql-db-subnet-a.id, aws_subnet.mysql-db-subnet-b.id ]
    tags = {
        Name = "Mysql DB Group"
    }
}
resource "aws_vpc_peering_connection" "peering-a-db" {    
    peer_vpc_id = aws_vpc.wordpress_a.id
    vpc_id = aws_vpc.mysql-db-vpc.id
    auto_accept = true
    tags = {
      "Name" = "VPC Peering between A and DB"
    }
}
resource "aws_vpc_peering_connection" "peering-b-db" {    
    peer_vpc_id = aws_vpc.wordpress_b.id
    vpc_id = aws_vpc.mysql-db-vpc.id
    auto_accept = true
    tags = {
      "Name" = "VPC Peering between B and DB"
    }
}
resource "aws_default_route_table" "db-a-b" {
    default_route_table_id = aws_vpc.mysql-db-vpc.default_route_table_id
    route {
        cidr_block = var.vpc_a_cidr
        gateway_id = aws_vpc_peering_connection.peering-a-db.id
    }
    route {
        cidr_block = var.vpc_b_cidr
        gateway_id = aws_vpc_peering_connection.peering-b-db.id
    }
    tags = {
        Name = "RT-DB-to-A-B"
    }
}
#----------RDS Network--------------------