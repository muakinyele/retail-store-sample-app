variable "name" {
type = string
description = "Name prefix for resources"
}


variable "cidr" {
type = string
description = "VPC CIDR block"
default = "10.0.0.0/16"
}


variable "availability_zones" {
type = list(string)
description = "List of AZs to create subnets in"
default = []
}