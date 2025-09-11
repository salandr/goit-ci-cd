
output "s3_bucket_name" {
  value = aws_s3_bucket.terraform_state.id
}

output "dynamodb_table_name" {
  value = aws_dynamodb_table.terraform_locks.name
}


output "bucket_url" {
  value = aws_s3_bucket.terraform_state.bucket
}
