module "lambda_with_api" {
  source         = "./modules/lambda"
  src_path       = "./src"
  description    = "Test lambda for cognito"
  name           = "cognito-dummy-poc"
  api_gateway_id = module.api.apigatewayv2_api_id
}

module "api" {
  source        = "terraform-aws-modules/apigateway-v2/aws"
  name          = "tf-cognito"
  protocol_type = "HTTP"
  integrations = {
    "ANY /" = {
      lambda_arn     = module.lambda_with_api.function_arn
      authorizer_key = "cognito-test-auth"
    }
  }
  create_api_domain_name = false

  authorizers = {
    "cognito-test-auth" = {
      authorizer_type  = "COGNITO_USER_POOLS"
      identity_sources = "$request.header.Authorization"
      name             = "cognito-test-auth"
    }
  }
}

module "cognito" {
  source = "./modules/cognito"
}

resource "aws_api_gateway_authorizer" "cognito_user_pool_authorizer" {
  name            = "cognito_user_pool_authorizer"
  rest_api_id     = module.api.apigatewayv2_api_id
  provider_arns   = [module.cognito.user_pool_arn]
  identity_source = "method.request.header.Authorization"
}


