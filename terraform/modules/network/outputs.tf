output "vpc_id" { value = aws_vpc.main.id }
output "private_subnet_id" { value = aws_subnet.private_subnet.id }
output "security_group_id" { value = aws_security_group.db_sg.id }
output "availability_zone" { value = "ap-south-1a" }