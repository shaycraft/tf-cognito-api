resource "aws_cognito_user_pool" "main" {
  name = "tf_user_pool_poc"
}

resource "aws_cognito_user_pool_client" "main" {
  name         = "tf_user_pool_client_poc"
  user_pool_id = aws_cognito_user_pool.main.id

  allowed_oauth_flows  = ["client_credentials"]
  allowed_oauth_scopes = []

  generate_secret = true
}

