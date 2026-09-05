output "address" {
    value = aws_db_instance.example.address
    description = "This is Mysql address to access"
}
output "port" {
    value = aws_db_instance.example.port
    description = "This is Mysql port to access"
}