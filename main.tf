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
      lambda_arn = module.lambda_with_api.function_arn
    }
  }
  create_api_domain_name = false
}

