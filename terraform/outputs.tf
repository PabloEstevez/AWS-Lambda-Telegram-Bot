output "base_url" {
  description = "Base URL for the Lambda function"
  value       = aws_lambda_function_url.telegram_bot
}

output "webhook_info" {
  description = "Status of the Telegram bot webhook"
  value       = data.http.telegram_webhook_info
}
