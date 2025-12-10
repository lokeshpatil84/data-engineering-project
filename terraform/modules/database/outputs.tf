output "endpoint" { 
  value = aws_db_instance.postgres.address 
}

output "username" { 
  value = aws_db_instance.postgres.username 
}

output "db_name" {
  value = aws_db_instance.postgres.db_name
}