variable "public_subnet_cidrs" {
 type        = list(string)
 description = "Public Subnet CIDR values"
 default     = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
}

variable "private_subnet_cidrs" {
 type        = list(string)
 description = "Private Subnet CIDR values"
 default     = ["10.0.4.0/24", "10.0.5.0/24", "10.0.6.0/24"]
}

variable "azs" {
 type        = list(string)
 description = "Availability Zones"
 default     = ["us-east-1a", "us-east-1b", "us-east-1c"]
}

variable "private_subnets_ipv6" {
 type        = list(string)
 description = "Private Subnet Ipv6 CIDR values"
 default     = ["2600:1f18:3243:7a01::/64", "2600:1f18:3243:7a02::/64", "2600:1f18:3243:7a03::/64"]
}