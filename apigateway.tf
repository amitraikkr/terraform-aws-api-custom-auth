variable "region" {
  description = "The AWS region to create resource"
  type = string
  default = "us-east-2"
}
resource "aws_api_gateway_rest_api" "MyApiAuth" {
    name = "myAPIAuth01"
    description = "API with custom lambda authorizer"
  
}

resource "aws_api_gateway_authorizer" "lambda_authorizer" {
    name = "myLambdaAuthorizer"
    rest_api_id = aws_api_gateway_rest_api.MyApiAuth.id
    authorizer_uri         = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${aws_lambda_function.authorizer_lambda.arn}/invocations"
    authorizer_result_ttl_in_seconds = 300
    identity_source        = "method.request.header.Authorization"
    type                   = "TOKEN"
  
}

resource "aws_api_gateway_resource" "api_resource" {
    rest_api_id = aws_api_gateway_rest_api.MyApiAuth.id
    parent_id = aws_api_gateway_rest_api.MyApiAuth.root_resource_id
    path_part = "myresource"
}

resource "aws_api_gateway_method" "api_method" {
    rest_api_id = aws_api_gateway_rest_api.MyApiAuth.id
    resource_id = aws_api_gateway_resource.api_resource.id
    http_method = "GET"
    authorization = "CUSTOM"
    authorizer_id = aws_api_gateway_authorizer.lambda_authorizer.id
}

resource "aws_api_gateway_integration" "api_integration" {
    rest_api_id = aws_api_gateway_rest_api.MyApiAuth.id
    resource_id = aws_api_gateway_resource.api_resource.id
    http_method = aws_api_gateway_method.api_method.http_method

    integration_http_method = "POST"
    type = "AWS_PROXY"
    uri = aws_lambda_function.authorizer_lambda.invoke_arn
  
}

resource "aws_api_gateway_deployment" "api_deployment" {
    depends_on = [ 
        aws_api_gateway_integration.api_integration
    ]
    rest_api_id = aws_api_gateway_rest_api.MyApiAuth.id
    stage_name = "prod"
}

resource "aws_lambda_permission" "api_gateway_permission" {
    statement_id = "AllowExecutionFromAPIGateway"
    action = "lambda:InvokeFunction"
    function_name = aws_lambda_function.authorizer_lambda.function_name
    principal = "apigateway.amazonaws.com"
    source_arn = "${aws_api_gateway_rest_api.MyApiAuth.execution_arn}/*/*"
  
}
