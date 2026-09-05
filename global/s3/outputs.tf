output "s3_bucket_arn" {
  value = aws_s3_bucket.example.arn
  description = "Arn value for s3 bucket"
}

output "dynamodb_name" {
    value = aws_dynamodb_table.dynamodb_table.name
    description = "name of dynamodb"
}