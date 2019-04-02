resource "aws_api_gateway_rest_api" "CarPlatesAPI" {
  name        = "Car plates API"
  description = "Api allowing to check if there are car plates h"
}

resource "aws_api_gateway_resource" "plate" {
  rest_api_id = "${aws_api_gateway_rest_api.CarPlatesAPI.id}"
  parent_id   = "${aws_api_gateway_rest_api.CarPlatesAPI.root_resource_id}"
  path_part   = "plate"
}

resource "aws_api_gateway_method" "FindCarPlate" {
  rest_api_id   = "${aws_api_gateway_rest_api.CarPlatesAPI.id}"
  resource_id   = "${aws_api_gateway_resource.platenumber.id}"
  http_method   = "GET"
  authorization = "COGNITO_USER_POOLS"
  authorization_scopes = ["ApiGateway/api.read"]
  authorizer_id = "${aws_api_gateway_authorizer.CognitoAuthorizer.id}"
}

resource "aws_api_gateway_resource" "platenumber" {
  rest_api_id = "${aws_api_gateway_rest_api.CarPlatesAPI.id}"
  parent_id   = "${aws_api_gateway_resource.plate.id}"
  path_part   = "{platenumber}"
}

resource "aws_api_gateway_integration" "FindCarPlateIntegration" {
  rest_api_id          = "${aws_api_gateway_rest_api.CarPlatesAPI.id}"
  resource_id          = "${aws_api_gateway_resource.platenumber.id}"
  http_method          = "${aws_api_gateway_method.FindCarPlate.http_method}"
  integration_http_method = "POST"
  type                 = "AWS"
  uri = "arn:aws:apigateway:${var.region}:dynamodb:action/Query"
  credentials = "${var.api_iam_role_arn}"

  request_templates = {
    "application/json" = <<EOF
{
    "TableName": "carPlates",
    "KeyConditionExpression": "platenumber = :v1",
    "ExpressionAttributeValues": {
        ":v1": {
            "S": "$input.params('platenumber')"
        }
    }
}
EOF
  }
}

resource "aws_api_gateway_method_response" "200" {
  rest_api_id = "${aws_api_gateway_rest_api.CarPlatesAPI.id}"
  resource_id = "${aws_api_gateway_resource.platenumber.id}"
  http_method = "${aws_api_gateway_method.FindCarPlate.http_method}"
  status_code = "200"
}

resource "aws_api_gateway_integration_response" "CarPlateFound" {
  depends_on = ["aws_api_gateway_integration.FindCarPlateIntegration"]
  rest_api_id = "${aws_api_gateway_rest_api.CarPlatesAPI.id}"
  resource_id = "${aws_api_gateway_resource.platenumber.id}"
  http_method = "${aws_api_gateway_method.FindCarPlate.http_method}"
  status_code = "${aws_api_gateway_method_response.200.status_code}"

  response_templates {
    "application/json" = <<EOF
#set($inputRoot = $input.path('$'))
{"plate_registered":#if($inputRoot.Count == '0')"false"#{else}"true"#end}
EOF
  }
}

resource "aws_api_gateway_authorizer" "CognitoAuthorizer" {
  name = "CognitoAuthorizer"
  rest_api_id = "${aws_api_gateway_rest_api.CarPlatesAPI.id}"
  type  = "COGNITO_USER_POOLS"
  identity_source = "method.request.header.Authorization"
  provider_arns = ["${var.cognito_user_pool_arn}"]
}

resource "aws_api_gateway_deployment" "CarPlateApiDeployment" {
  depends_on = ["aws_api_gateway_integration.FindCarPlateIntegration"]

  rest_api_id = "${aws_api_gateway_rest_api.CarPlatesAPI.id}"
  stage_name  = "${var.stage}"

  stage_description = "${md5(file("infrastructure/modules/api_gateway/api.tf"))}"
}

resource "aws_api_gateway_method_settings" "settings" {
  rest_api_id = "${aws_api_gateway_rest_api.CarPlatesAPI.id}"
  stage_name  = "${aws_api_gateway_deployment.CarPlateApiDeployment.stage_name}"
  method_path = "*/*"

  settings {
    metrics_enabled = true
    data_trace_enabled = true
    logging_level   = "INFO"
  }
}

resource "aws_api_gateway_account" "api_account" {
  cloudwatch_role_arn = "${var.cloudwatch_arn}"
}
