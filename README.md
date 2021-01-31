# AWS-Lambda-Telegram-Bot
Telegram bot hosted on an AWS Lambda function for FREE.

## Setup

### 1. Create lambda function.
Go to the AWS console and create a new lambda function. Then, set the file *template.py* as the main function code and the function *lambda_handler()* as the main handler.

### 2. Add a trigger.
We will need to add a trigger to the function. The best way that I can come up with is setting an API Gateway.

### 3. Configure the API Gateway.
Set the API Gateway up as a REST API without authorization. Once done, save the API endpoint URL for later.

```
WARNING!: 
I am aware that setting up the API without any authentication is a considerable risk to be taken into account. 
If someone knows your API endpoint, they can bombard it with requests 
and give you a not so funny bill at the end of the month. 
It is advisable to set up CloudWatch metrics to monitor and limit this kind of attacks.
```

### 4. Configure the Telegram Bot webhook.
We will configure the telegram bot to notify all the updates to the just-created API Gateway using a really convenient feature, webhooks. The only thing you need to do is follow the next link into your browser, changing the bot token and API endpoint.

```
https://api.telegram.org/bot<TOKEN>/setWebhook?url=<API Gateway endpoint>
```

### 5. Customize.
The code given in the file *template.py* is an example with several test functions. You should implement your own functionalities.


## Code structure

The main goal is to come up with the cleanest, most scalable and secure way to implement a telegram bot. To achieve this, I have divided the script in several parts:

### CONSTANTS
Here you should set any constant needed for your bot. In my example, I use IFTTT to control my home lights, so here I define the IFTTT token key, for example.

Another interesting variable here are groups. My idea is to make several groups with different permissions, so that each group can execute some functions based on the role asigned by you. You should put there an array of **telegram usernames**. In my example I just defined 2 groups, *sudoers*, that can execute all functions (I usually place only myself here) and *family*, where I place my family members to grant them the control of the home lights.

### HELPERS
A set of methods that are not directly executed by the end user. Very similar to private methods.

### FUNCTIONS
A set of methods that can be executed by the end user. All of them has the same parameter (message). This way, we are standardizing the function calls:
```python
*function_name*(message)
```
Later on we will see the power of this feature.

### COMMAND-FUNCTION BINDINGS
We define a dictionary for each group plus an extra one with the functions available for all groups. These dictionaries contain the commands that the end user gives to the bot as keys and the functions associated to each command as value.

### HANDLER
This is the main method. When a callback hits the API Gateway, the lambda function is executed calling this method first. Here I have standardized the function calling, so when a user gives us the command "/chatid", this method grabs the first word, checks if it is a command, and looks for the function asociated to it in the corresponding group dictionary. If the function is found in the group dictionary, it is called passing allways the same parameter, the original message object. In this case, the command "/chatid" would execute the function "chat_id(message)". The functions should return the response given to the user.

Keep in mind that this script is executed once per user message, so you cannot persist any information in variables. To make the information persistent between calls I suggest usig AWS DynamoDB, an allways free DB service.
