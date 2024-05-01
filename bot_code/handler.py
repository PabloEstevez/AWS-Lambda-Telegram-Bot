import json
import os
import urllib.request
import urllib.parse

URL = f"https://api.telegram.org/bot{os.getenv('BOT_TOKEN')}/"
ADMINS = os.getenv('BOT_ADMINS').split(",")
USERS = os.getenv('BOT_USERS').split(",")
AUTH_TOKEN = os.getenv('AUTH_TOKEN')


## HELPERS ##
def send_message(text, chat_id):
    url = URL + f"sendMessage?text={text}&chat_id={chat_id}"
    urllib.request.urlopen(
        urllib.request.Request(url.replace(" ","+"), headers={'Accept': 'application/json'}),
        timeout=1
    )


## FUNCTIONS ##
def template(message):
    return("This is a template function.")

def echo(message):
    return(message['text'])

def check_id(message):
    return(message['chat']['id'])


## COMMAND-FUNCTION BINDINGS ##
function_dict = {"/echo":echo}
users_function_dict = {**function_dict, "/template":template}
admins_function_dict = {**users_function_dict, "/checkid":check_id}


## HANDLER ##
def lambda_handler(event, context):
    print("[EVENT]",json.dumps(event))
    if 'x-telegram-bot-api-secret-token' not in event['headers'] or event['headers']['x-telegram-bot-api-secret-token'] != AUTH_TOKEN: return {'statusCode': 401}
    message = json.loads(event['body'])['message']
    chat_id = message['chat']['id']
    if str(message['from']['id']) in ADMINS: functions = admins_function_dict
    elif str(message['from']['id']) in USERS: functions = users_function_dict
    else: functions = function_dict
    command = message['text'].split(' ')[0]
    if '/' not in command: reply="I can't understand you"
    elif command not in functions.keys(): reply = f"Command {command} is not available"
    else: reply = functions[command](message)
    send_message(reply, chat_id)
    return {'statusCode': 200}
