# AWS Lambda Telegram Bot

This project involves hosting a Telegram bot on an AWS Lambda function. Below are the setup instructions and an overview of the code structure.

## Setup

The bot can be automatically deployed using Terraform. For that, you will need to export AWS authentication variables (and assume the right role if necessary).

```bash
export AWS_ACCESS_KEY_ID=AKIAIOSFODNN7EXAMPLE
export AWS_SECRET_ACCESS_KEY=wJalrXUtnFEMI/K7MDENG/bPxRfiCYEXAMPLEKEY
```

Then, create a `terraform.tfvars` file in the `terraform/` directory with your custom configuration for the module. You can find all the variables you can set in the file `terraform/variables.tf`. The only mandatory variables are:

```hcl
telegram_bot_token = "123456789:Y0URR4ND0MB0TT0K3NH3R3"
telegram_bot_admins = "123456789"
telegram_bot_users = "987654321,135792468"
```

After that, run the following command to deploy the bot:

```bash
cd terraform
terraform plan
terraform apply
```

## Code Structure

The goal is to implement a clean, scalable, and secure Telegram bot. The script is organized into several parts:

### Helpers

These methods are not directly executed by end users and serve as utility functions (similar to private methods).

### Functions

Methods that can be executed by end users. All functions accept a common parameter (`message`), standardizing function calls:

```python
function_name(message)
```

### Command-Function Bindings
We define dictionaries for each user group, along with an additional one for functions available to all groups. These dictionaries map user commands to associated functions.


### Handler

The handler method is executed when a callback hits the function URL, invoking the AWS Lambda function. In this method, I've standardized the function calling process. When a user provides a command (e.g., `/chatid`), the method extracts the first word, checks if it corresponds to a valid command, and looks up the associated function in the corresponding group dictionary. For example, if the user enters the command `/chatid`, the function `chat_id(message)` is executed, always passing the original message object as a parameter. The functions should return the appropriate response to the user.

Keep in mind that this script is executed once per user message, so you cannot persist information in variables across calls. To maintain data between interactions, consider using an external database like AWS DynamoDB.
