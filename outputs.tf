output "arn" {
  #   value = module.api.default_apigatewayv2_stage_invoke_url
  value = module.cognito.user_pool_arn
}

output "api_endpoint" {
  value = aws_api_gateway_deployment.api_deployment.invoke_url
}

output "token_url" {
  value = module.cognito.token_url
}

output "cognito_domain" {
  value = module.cognito.domain
}