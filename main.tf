provider "aws" {
  region = "us-west-2"
}

module "lambda" {
  source        = "terraform-aws-modules/lambda/aws"
  function_name = "test-lambda"

  source_path = "./src"
  handler     = "index.handler"
  runtime     = "nodejs14.x"
  publish     = true

  allowed_triggers = {
    AllowExecutionFromAPIGateway = {
      service    = "apigateway"
      source_arn = "${module.api.apigatewayv2_api_execution_arn}/*/*"
    }
  }

  tags = {
    "Name" = "terraform test lambda"
  }
}

module "api" {
  source        = "terraform-aws-modules/apigateway-v2/aws"
  name          = "tf-cognito"
  protocol_type = "HTTP"
  integrations = {
    "ANY /" = {
      lambda_arn = module.lambda.lambda_function_arn
    }
  }
  create_api_domain_name = false
}

output "url" {
  value = module.api.default_apigatewayv2_stage_invoke_url
}