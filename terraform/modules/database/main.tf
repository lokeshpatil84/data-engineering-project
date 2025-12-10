resource "aws_db_subnet_group" "default" {
  name       = "main_subnet_group"
  subnet_ids = var.subnet_ids
  
  tags = {
    Name = "My DB subnet group"
  }
}

resource "aws_db_instance" "postgres" {
  allocated_storage    = 20
  storage_type         = "gp2"
  engine               = "postgres"
  engine_version       = "14"
  instance_class       = "db.t3.micro"
  db_name              = "source_db"
  username             = "postgres"
  password             = var.db_password
  parameter_group_name = "default.postgres14"
  skip_final_snapshot  = true
  publicly_accessible  = true 
  vpc_security_group_ids = [var.sg_id]
  db_subnet_group_name   = aws_db_subnet_group.default.name
}