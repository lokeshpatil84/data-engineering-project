output "vpc_id" { value = aws_vpc.main.id }

output "private_subnet_ids" { 
  value = [aws_subnet.private_subnet_1.id, aws_subnet.private_subnet_2.id] 
}

output "security_group_id" { value = aws_security_group.db_sg.id }

output "primary_subnet_id" { value = aws_subnet.private_subnet_1.id }