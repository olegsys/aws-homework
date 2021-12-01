variable "aws_access_key_id" {
  description = "AWS Access Key ID"
  type = string  
}
variable "aws_secret_access_key" {
  description = "AWS Secret Key"
  type = string
}
variable "region" {
  type = string
  default = "eu-west-2"
}
variable "zone_a" {
  type = string
  default = "eu-west-2a"
}
variable "zone_b" {
  type = string
  default = "eu-west-2b"
}
variable "vpc_a_cidr" {
  description = "CIDR Block for Network in A AZ"
  type = string
  default = "10.10.0.0/16"
}
variable "vpc_b_cidr" {
  description = "CIDR Block for Network in B AZ"
  type = string
  default = "10.20.0.0/16"
}
variable "sbnt_a_cidr" {
  description = "CIDR Block for subnet in A AZ"
  type = string
  default = "10.10.1.0/24"
}
variable "sbnt_b_cidr" {
  description = "CIDR Block for subnet in B AZ"
  type = string
  default = "10.20.1.0/24"
}
variable "vpc_db_cidr" {
  description = "CIDR Block for VPC Database"
  type = string
  default = "172.30.0.0/16"
}
variable "sbnt_db-a_cidr" {
  description = "CIDR Block for DB Subnet A"
  type = string
  default = "172.30.1.0/24"
}
variable "sbnt_db-b_cidr" {
  description = "CIDR Block for DB Subnet B"
  type = string
  default = "172.30.2.0/24"
}
variable "ami_id" {
  description = "ID AMI Linux image"
  type = string
  default = "ami-0fc15d50d39e4503c"  
}
variable "efs_ip" {
  description = "IP Address EFS mount point"
  type = string
  default = "10.10.1.253"
}
variable "zone_id" {
  description = "Zone ID in Cloudflare"
  type = string
}
variable "cloudflare_api_token" {
  description = "API Token for Cloudflare"
  type = string    
}