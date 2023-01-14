terraform {
  cloud {
    organization = "mr-gav-meow"

    workspaces {
      name = "tf-cognito-api"
    }
  }
}
