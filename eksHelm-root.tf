provider "aws" {
  region                  = "us-east-1"
}

module "vpc"{
    source = "./modules/vpc"

    cidr = var.cidr
    pubsubnetcidrs = var.pubsubnetcidrs
    privsubnetcidrs = var.privsubnetcidrs
    azs = var.azs
    environment = var.environment
}

module "eks"{
    source = "./modules/eks"

    subnet1id = module.vpc.subnet1id
    subnet2id = module.vpc.subnet2id
    environment = var.environment
}

terraform {
  backend "s3" {
    bucket = "dw-terraform-backend"
    key    = "eks-helm-demo"
    region = "us-east-1"
  }
}

variable "environment"{}
variable "cidr"{}
variable "pubsubnetcidrs"{
  type        = list(string)
}
variable "privsubnetcidrs"{
  type        = list(string)
}
variable "azs"{
  type        = list(string)
}