provider "aws" {
  alias = "region"
}

data "aws_region" "current" {}

module "lambda_with_api" {
  source         = "./modules/lambda"
  src_path       = "./src"
  description    = "Test lambda for cognito"
  name           = "cognito-dummy-poc"
  api_gateway_id = aws_api_gateway_rest_api.tf_cognito_poc_api.id
}

module "cognito" {
  source = "./modules/cognito"
}

resource "aws_api_gateway_rest_api" "tf_cognito_poc_api" {
  name        = "tf_cognito_poc_api"
  description = "Terraform Cognito POC API"

  endpoint_configuration {
    types = ["REGIONAL"]
  }
}


resource "aws_api_gateway_authorizer" "cognito_user_pool_authorizer" {
  name            = "cognito_user_pool_authorizer"
  type            = "COGNITO_USER_POOLS"
  rest_api_id     = aws_api_gateway_rest_api.tf_cognito_poc_api.id
  provider_arns   = [module.cognito.user_pool_arn]
  identity_source = "method.request.header.Authorization"
}

resource "aws_api_gateway_resource" "my_resource" {
  parent_id   = aws_api_gateway_rest_api.tf_cognito_poc_api.root_resource_id
  path_part   = "{proxy+}"
  rest_api_id = aws_api_gateway_rest_api.tf_cognito_poc_api.id
}

resource "aws_api_gateway_method" "my_method" {
  authorization = "COGNITO_USER_POOLS"
  http_method   = "GET"
  resource_id   = aws_api_gateway_resource.my_resource.id
  rest_api_id   = aws_api_gateway_rest_api.tf_cognito_poc_api.id
  authorizer_id = aws_api_gateway_authorizer.cognito_user_pool_authorizer.id
}

resource "aws_api_gateway_integration" "my_integration" {
  http_method             = aws_api_gateway_method.my_method.http_method
  resource_id             = aws_api_gateway_resource.my_resource.id
  rest_api_id             = aws_api_gateway_rest_api.tf_cognito_poc_api.id
  integration_http_method = "POST"
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${data.aws_region.current.name}:lambda:path/2015-03-31/functions/${module.lambda_with_api.function_arn}/invocations"


}

resource "aws_api_gateway_deployment" "my_deployment" {
  rest_api_id = aws_api_gateway_rest_api.tf_cognito_poc_api.id
  depends_on  = [aws_api_gateway_integration.my_integration]
  stage_name  = "dev"
}