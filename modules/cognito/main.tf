resource "aws_cognito_user_pool" "main" {
  name = "my_user_pool"
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "my_user_pool_client"
  user_pool_id = aws_cognito_user_pool.main.id

  allowed_oauth_flows  = ["client_credentials"]
  allowed_oauth_scopes = ["phone", "email", "openid", "profile", "aws.cognito.signin.admin"]

  generate_secret = true
}

