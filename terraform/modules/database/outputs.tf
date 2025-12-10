output "endpoint" { value = aws_db_instance.postgres.address }
output "db_name" { value = aws_db_instance.postgres.db_name }
output "username" { value = aws_db_instance.postgres.username }