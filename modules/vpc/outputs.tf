output "vpcId"{
    value = aws_vpc.tf-vpc.id
}

output "subnet1id"{
    value = aws_subnet.privatesubnet[0].id
}

output "subnet2id"{
    value = aws_subnet.privatesubnet[1].id
}

output "securitygroupid"{
    value = aws_security_group.security-group1.id
}