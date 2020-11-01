variable "cidr" {
  description = "The VPC cidr block"
  default = "10.0.0.0/16"
}

variable "environment" {
  description = "The name of the environment"
  default = "Terraform_Project"
}

variable "pubsubnetcidrs" {
  type = list(string)
  description = "cidr blocks for public subnets"
}

variable "privsubnetcidrs" {
  type = list(string)
  description = "cidr blocks for private subnets"
}

variable "azs" {
  description = "List of availability zones names in the region"
  type        = list(string)
}