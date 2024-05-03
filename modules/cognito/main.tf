resource "aws_cognito_user_pool" "main" {
  name = "tf_user_pool_poc"
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "tf_user_pool_client_poc"
  user_pool_id = aws_cognito_user_pool.main.id

  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes                 = ["poc/read"]
  allowed_oauth_flows_user_pool_client = true

  explicit_auth_flows = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH",
  "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]


  generate_secret = true

  access_token_validity  = 12
  id_token_validity      = 12
  refresh_token_validity = 1

  token_validity_units {
    access_token  = "hours"
    id_token      = "hours"
    refresh_token = "days"
  }
}

resource "aws_cognito_resource_server" "cognito_resource_server" {
  identifier = "poc"
  name       = "tf_resource_server_poc"

  user_pool_id = aws_cognito_user_pool.main.id

  scope {
    scope_description = "POC scope"
    scope_name        = "read"
  }
}

resource "aws_cognito_user_pool_domain" "cognito_domain" {
  domain       = "tf-ev-poc-sso"
  user_pool_id = aws_cognito_user_pool.main.id
}