resource "aws_iam_role" "lambda_exec_role" {
  name = "lambda_execution_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Principal = {
        Service = "lambda.amazonaws.com"
      }
    }]
  })
}

resource "aws_iam_role_policy" "lambda_policy" {
    name = "lambda_policy"
    role = aws_iam_role.lambda_exec_role.id

    policy = jsonencode({
        Version = "2012-10-17"
        Statement = [
            {
                Action = [
                    "logs:CreateLogGroup",
                    "logs:CreateLogStream",
                    "logs:PutLogEvents"
                ],
                Effect = "Allow"
                Resource = "arn:aws:logs:*:*:*"
            }
        ]
    })  
}

resource "aws_lambda_function" "authorizer_lambda" {
    function_name = "customAuthorizerLambda"
    role = aws_iam_role.lambda_exec_role.arn

    handler = "index.handler"
    runtime = "nodejs18.x"

    filename = "index.zip"
    source_code_hash = filebase64sha256("index.zip")

    environment {
      variables = {
        SOME_ENV_VAR = "value"
      }
    }
}

