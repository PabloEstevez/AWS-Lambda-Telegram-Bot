####################
# LAMBDA FUNCTION
####################

data "archive_file" "bot_code" {
  type             = "zip"
  source_dir       = "${path.module}/../bot_code/"
  output_file_mode = "0666"
  output_path      = "${path.module}/../dist/bot_code.zip"
}

resource "aws_lambda_function" "telegram_bot" {
  function_name = var.name
  filename = "${path.module}/../dist/bot_code.zip"
  runtime = "python3.12"
  handler = "handler.lambda_handler"
  source_code_hash = data.archive_file.bot_code.output_base64sha256
  role = aws_iam_role.lambda_exec.arn

  environment {
    variables = {
      BOT_TOKEN  = var.telegram_bot_token
      BOT_ADMINS = var.telegram_bot_admins
      BOT_USERS  = var.telegram_bot_users
      AUTH_TOKEN = random_password.secret_token.result
    }
  }
}

resource "aws_lambda_function_url" "telegram_bot" {
  function_name      = aws_lambda_function.telegram_bot.function_name
  authorization_type = "NONE"
}

resource "aws_cloudwatch_log_group" "telegram_bot" {
  name = "/aws/lambda/${aws_lambda_function.telegram_bot.function_name}"

  retention_in_days = var.log_retention_days
}

resource "aws_iam_role" "lambda_exec" {
  name = "serverless_lambda"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Action = "sts:AssumeRole"
      Effect = "Allow"
      Sid    = ""
      Principal = {
        Service = "lambda.amazonaws.com"
      }
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}


####################
# TELEGRAM WEBHOOK
####################

data "http" "telegram_webhook" {
  url    = "https://api.telegram.org/bot${var.telegram_bot_token}/setWebhook?url=${aws_lambda_function_url.telegram_bot.function_url}&max_connections=${var.telegram_bot_max_connections}&allowed_updates=${jsonencode(var.telegram_bot_allowed_updates)}&secret_token=${random_password.secret_token.result}&drop_pending_updates=True"
  method = "GET"
}

resource "random_password" "secret_token" {
  length           = 128
  override_special = "-_"
}

data "http" "telegram_webhook_info" {
  url    = "https://api.telegram.org/bot${var.telegram_bot_token}/getWebhookInfo"
  method = "GET"
  depends_on = [data.http.telegram_webhook]
}
