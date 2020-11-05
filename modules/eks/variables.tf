variable "environment" {
  description = "The name of the environment"
  default = "Terraform_Project"
}

variable "subnet1id"{
    description = "The subnet for the lambda function"
}

variable "subnet2id"{
    description = "The subnet for the lambda function"
}

variable "desired_size"{
  description = "Desired number of nodes for node group"
  default = 2
}

variable "max_size"{
  description = "Max number of nodes for node group"
  default = 3
}

variable "min_size"{
  description = "Min number of nodes for node group"
  default = 1
}