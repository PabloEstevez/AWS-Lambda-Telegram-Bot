variable "aws_region" {
  description = "AWS region where resources will be created"
  type        = string
  default     = "eu-west-1"
}

variable "name" {
  description = "Name given to a particular instance of the telegram bot"
  type        = string
  default     = "lambda_telegram_bot"
}

variable "log_retention_days" {
  description = "Number of days to retain logs in CloudWatch"
  type        = number
  default     = 30
}

variable "telegram_bot_max_connections" {
  description = "The maximum allowed number of simultaneous connections to the webhook for update delivery"
  type        = number
  default     = 1
}

variable "telegram_bot_allowed_updates" {
  description = "List of the update types the bot is able to receive (https://core.telegram.org/bots/api#update)"
  type        = list(string)
  default     = ["message"]
}

variable "telegram_bot_token" {
  description = "Telegram bot token (generated with botfather)"
  type        = string
}

variable "telegram_bot_admins" {
  description = "List of telegram chat IDs of users with administrator privileges. It must be a single string with the IDs separated by a comma without spaces."
  type        = string
}

variable "telegram_bot_users" {
  description = "List of telegram chat IDs of users with regular privileges. It must be a single string with the IDs separated by a comma without spaces."
  type        = string
}