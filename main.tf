provider "aws" {
  region = "us-east-1"
}
#1.IAM role for execute lambda
resource "aws_iam_role" "iam_role_exec_lambda_udacity1" {
name = "iam_role_exec_lambda_udacity1"
assume_role_policy = <<EOF
{
"Version": "2012-10-17",
"Statement": [
   {
     "Action": "sts:AssumeRole",
     "Principal": {
       "Service": "lambda.amazonaws.com"
     },
     "Effect": "Allow",
     "Sid": ""
   }
]
}
EOF
}
#2. Create logging policy
resource "aws_iam_policy" "function_logging_policy" {
  name   = "function-logging-policy"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        Action : [
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ],
        Effect : "Allow",
        Resource : "arn:aws:logs:*:*:*"
      }
    ]
  })
}

#3.Lambda function
resource "aws_lambda_function" "udacity_lambda_test" {
  filename      = "greet_lambda.zip"
  function_name = "udaciy_greeting"
  role          = aws_iam_role.iam_role_exec_lambda_udacity1.arn
  handler       = "greet_lambda.lambda_handler"

  source_code_hash = filebase64sha256("greet_lambda.zip")

  runtime = "python3.9" 

  environment {
   variables = {
     greeting = "Hello, udacity"
   }
  }
}

#4.Cloudwatch log group
resource "aws_cloudwatch_log_group" "udaciy_greeting" {
  name              = "/aws/lambda/udaciy_greeting"
  retention_in_days = 5
}

#5.Attach logging policy to function role
resource "aws_iam_role_policy_attachment" "function_logging_policy_attachment" {
  role = aws_iam_role.iam_role_exec_lambda_udacity1.id
  policy_arn = aws_iam_policy.function_logging_policy.arn
}
