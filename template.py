import json
from botocore.vendored import requests

BOT_TOKEN='CHANGEME'
IFTTT_TOKEN='CHANGEME'
URL = "https://api.telegram.org/bot{}/".format(BOT_TOKEN)
sudoers = ["changeme"]
family = ["changeme", "changeme"]


## HELPERS ##
def send_message(text, chat_id):
    url = URL + "sendMessage?text={}&chat_id={}".format(text, chat_id)
    requests.get(url)
    

## FUNCTIONS ##
def ifttt(message):
    command = message['text'].split(' ')[1]
    requests.get("https://maker.ifttt.com/trigger/{}/with/key/{}".format(command, IFTTT_TOKEN))
    return("IFTTT command executed: {}".format(comando.upper()))

def echo(message):
    return(message['text'])

def check_id(message):
    return(message['chat']['id'])
    

## COMMAND-FUNCTION BINDINGS ##
function_dict = {"/echo":echo}
family_function_dict = {**function_dict, "/ifttt":ifttt}
sudoers_function_dict = {**family_function_dict, "/checkid":check_id}


## HANDLER ##
def lambda_handler(event, context):
    message = json.loads(event['body'])['message']
    chat_id = message['chat']['id']
    if message['from']['username'] in sudoers: functions = sudoers_function_dict
    elif message['from']['username'] in family: functions = family_function_dict
    else: functions = function_dict
    command = message['text'].split(' ')[0]
    if '/' not in command: reply="I can't understand you"
    else: reply = functions[command](message)
    send_message(reply, chat_id)
    return {'statusCode': 200}
