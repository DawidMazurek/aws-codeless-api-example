resource "aws_cognito_user_pool" "ApiUsers" {
  name = "Api clients"
  tags {
    "project" = "codeless api"
  }
}

resource "aws_cognito_resource_server" "ApiClientsResourceServer" {
  identifier = "ApiGateway"
  name = "ApiGateway"
  user_pool_id = "${aws_cognito_user_pool.ApiUsers.id}"

  scope {
    scope_name        = "api.read"
    scope_description = "Access to car plates api reads"
  }

  scope {
    scope_name        = "api.write"
    scope_description = "Access to car plates api writes"
  }
}

resource "aws_cognito_user_pool_domain" "UserPoolDomainFrankfurt" {
  domain       = "carplates-api-auth-${var.stage}"
  user_pool_id = "${aws_cognito_user_pool.ApiUsers.id}"
}


resource "aws_cognito_user_pool_client" "api-client" {
  depends_on = ["aws_cognito_resource_server.ApiClientsResourceServer"]

  name = "sample-client"

  generate_secret = true
  allowed_oauth_flows_user_pool_client = true
  allowed_oauth_flows = ["client_credentials"]
  allowed_oauth_scopes = ["ApiGateway/api.read", "ApiGateway/api.write"]

  user_pool_id = "${aws_cognito_user_pool.ApiUsers.id}"
}
