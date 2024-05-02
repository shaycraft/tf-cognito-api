output "user_pool_arn" {
  value = aws_cognito_user_pool.main.arn
}

output "token_url" {
  value = aws_cognito_user_pool.main.endpoint
}

output "domain" {
  value = aws_cognito_user_pool.main.domain
}