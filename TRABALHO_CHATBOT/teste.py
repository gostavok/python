import json

# Seu JSON com as mensagens
json_data = '''

{
  "sender_id": "teste",
  "slots": {
    "session_started_metadata": null
  },
  "latest_message": {
    "intent": {},
    "entities": [],
    "text": null,
    "message_id": null,
    "metadata": {}
  },
  "latest_event_time": 1697570294.2090728,
  "followup_action": null,
  "paused": false,
  "events": [
    {
      "event": "action",
      "timestamp": 1697570294.2090728,
      "metadata": {
        "model_id": "cbd1ade83b7c438792e3bed72da864ba",
        "assistant_id": "20231015-143612-religious-hotel"
      },
      "name": "action_session_start",
      "policy": null,
      "confidence": 1.0,
      "action_text": null,
      "hide_rule_turn": false
    },
    {
      "event": "session_started",
      "timestamp": 1697570294.2090728,
      "metadata": {
        "model_id": "cbd1ade83b7c438792e3bed72da864ba",
        "assistant_id": "20231015-143612-religious-hotel"
      }
    },
    {
      "event": "action",
      "timestamp": 1697570294.2090728,
      "metadata": {
        "model_id": "cbd1ade83b7c438792e3bed72da864ba",
        "assistant_id": "20231015-143612-religious-hotel"
      },
      "name": "action_listen",
      "policy": null,
      "confidence": null,
      "action_text": null,
      "hide_rule_turn": false
    }
  ],
  "latest_input_channel": null,
  "active_loop": {},
  "latest_action": {
    "action_name": "action_listen"
  },
  "latest_action_name": "action_listen"
}
'''

# Carregue o JSON
data = json.loads(json_data)

# Acesse as mensagens
messages = data['events']

# Imprima as mensagens
for message in messages:
    if message['event'] == 'user':
        print(f"Usuário: {message['text']}")
    elif message['event'] == 'bot':
        print(f"Bot: {message['text']}")
