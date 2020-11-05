# This is the name of the environment 
environment     = "dev"

# This is the cidr range for the vpc
cidr            = "10.0.0.0/16"

#This is a list of the cidr ranges for the public subnets
#The number of subnets is determined by how many cidr ranges are set here
pubsubnetcidrs  = ["10.0.1.0/24" , "10.0.2.0/24"]

#This is a list of the cidr ranges for the private subnets
#The number of subnets is determined by how many cidr ranges are set here
privsubnetcidrs = ["10.0.3.0/24" , "10.0.4.0/24"]

#This sets which availability zones are used for your subnets
azs             = ["us-east-1a" , "us-east-1b"]

#This sets the desired number of nodes (EC2 instances) for your eks node group
desired_size    = 2

#This sets the mx number of nodes (EC2 instances) for your eks node group
max_size        = 3

#This sets the min number of nodes (EC2 instances) for your eks node group
min_size        = 1