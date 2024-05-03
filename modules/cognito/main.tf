resource "aws_cognito_user_pool" "main" {
  name = "tf_user_pool_poc"
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "tf_user_pool_client_poc"
  user_pool_id = aws_cognito_user_pool.main.id

  allowed_oauth_flows                  = ["client_credentials"]
  allowed_oauth_scopes                 = ["ev/read"]
  allowed_oauth_flows_user_pool_client = true

  explicit_auth_flows = ["ALLOW_ADMIN_USER_PASSWORD_AUTH", "ALLOW_CUSTOM_AUTH",
  "ALLOW_USER_SRP_AUTH", "ALLOW_REFRESH_TOKEN_AUTH"]


  generate_secret = true
}

resource "aws_cognito_resource_server" "cognito_resource_server" {
  identifier = "ev"
  name       = "ev"

  user_pool_id = aws_cognito_user_pool.main.id

  scope {
    scope_description = "POC scope"
    scope_name        = "read"
  }
}