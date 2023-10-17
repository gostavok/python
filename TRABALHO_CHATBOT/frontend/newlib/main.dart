import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

void main() => runApp(const ChatApp());

class ChatApp extends StatelessWidget {
  const ChatApp({super.key});

  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      home: ChatScreen(),
    );
  }
}

class ChatScreen extends StatefulWidget {
  const ChatScreen({super.key});

  @override
  State createState() => ChatScreenState();
}

class ChatScreenState extends State<ChatScreen> {
  final List<ChatMessage> _messages = <ChatMessage>[];
  final TextEditingController _textController = TextEditingController();
  final TextEditingController usernameField = TextEditingController();
  bool isUsernameSet = false;
  String username = "";

  void _handleUsernameSubmitted() async {
    if (isUsernameSet) {
      return; // Evitar chamadas repetidas
    }

    username = usernameField.text;

    setState(() {
      isUsernameSet = true;
    });

    // Construa a URL para a requisição do nome de usuário
    final url = Uri.parse('http://localhost:5005/conversations/$username/tracker');

    // Enviar a requisição POST com o nome de usuário
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      if (responseJson['events'] != null) {
        List<dynamic> messages = responseJson['events'];

        for (var message in messages) {
          if (message['event'] == 'user' && message['text'] != null) {
            ChatMessage userMessage = ChatMessage(
              text: message['text'],
              username: username,
            );
            setState(() {
              _messages.insert(0, userMessage);
            });
          } else if (message['event'] == 'bot' && message['text'] != null) {
            _addBotMessage(message['text']);
          }
        }
      }
    } else {
      // Requisição falhou
      print('Falha ao enviar a mensagem. Código de status: ${response.statusCode}');
    }
  }

  void _handleSubmitted(String text) async {
    _textController.clear();
    ChatMessage userMessage = ChatMessage(
      text: text,
      username: username,
    );
    setState(() {
      _messages.insert(0, userMessage);
    });

    // Construa a URL para a requisição
    final url = Uri.parse('http://localhost:5005/webhooks/rest/webhook');

    // Enviar a requisição POST com a mensagem
    final response = await http.post(
      url,
      headers: {
        'Content-Type': 'application/json',
      },
      body: json.encode({
        'sender': username,
        'message': text,
      }),
    );

    if (response.statusCode == 200) {
      final responseJson = json.decode(response.body);

      if (responseJson is List) {
        for (var item in responseJson) {
          if (item['text'] != null) {
            _addBotMessage(item['text']);
          }
        }
      }
    } else {
      // Requisição falhou
      print('Falha ao enviar a mensagem. Código de status: ${response.statusCode}');
    }
  }

  void _addBotMessage(String text) {
    ChatMessage botMessage = ChatMessage(
      text: text,
      username: 'Fink bot',
      isBot: true,
    );

    setState(() {
      _messages.insert(0, botMessage);
    });
  }

  void _removeUsername() {
    setState(() {
      isUsernameSet = false;
      username = "";
      _messages.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Fink Bot'),
        backgroundColor: Colors.purple,
      ),
      body: Column(
        children: <Widget>[
          if (!isUsernameSet)
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Expanded(
                    child: TextField(
                      controller: usernameField,
                      decoration: const InputDecoration(
                        hintText: 'Insira seu nome',
                      ),
                    ),
                  ),
                  ElevatedButton(
                    style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.purple)),
                    onPressed: _handleUsernameSubmitted,
                    child: const Text('Enviar'),
                  ),
                ],
              ),
            ),
          if (isUsernameSet)
            Flexible(
              child: ListView.builder(
                padding: const EdgeInsets.all(8.0),
                reverse: true,
                itemBuilder: (_, int index) => _buildMessage(_messages[index]),
                itemCount: _messages.length,
              ),
            ),
          if (isUsernameSet) const Divider(height: 1.0),
          if (isUsernameSet)
            Container(
              decoration: BoxDecoration(color: Theme.of(context).cardColor),
              child: _buildTextComposer(),
            ),
          if (isUsernameSet)
            ElevatedButton(
              style: ButtonStyle(backgroundColor: MaterialStateProperty.all(Colors.red)),
              onPressed: _removeUsername,
              child: const Text('Sair'),
            ),
        ],
      ),
    );
  }

  Widget _buildTextComposer() {
    return IconTheme(
      data: const IconThemeData(color: Colors.purple),
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 8.0),
        child: Row(
          children: <Widget>[
            Flexible(
              child: TextField(
                controller: _textController,
                onSubmitted: _handleSubmitted,
                decoration: const InputDecoration.collapsed(
                  hintText: 'Envie sua mensagem',
                ),
              ),
            ),
            IconButton(
              icon: const Icon(Icons.send),
              onPressed: () => _handleSubmitted(_textController.text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMessage(ChatMessage message) {
    final isBotMessage = message.isBot;
    final messageColor = isBotMessage ? Colors.purple : Colors.black;
    final messageAlignment = isBotMessage ? MainAxisAlignment.start : MainAxisAlignment.end;

    return Container(
      margin: const EdgeInsets.symmetric(vertical: 10.0),
      child: Row(
        mainAxisAlignment: messageAlignment,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            margin: const EdgeInsets.only(right: 16.0),
            child: CircleAvatar(backgroundColor: messageColor),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  message.username,
                  style: TextStyle(fontWeight: FontWeight.bold, color: messageColor),
                ),
                Container(
                  margin: const EdgeInsets.only(top: 5.0),
                  child: Text(
                    message.text,
                    style: TextStyle(color: messageColor),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class ChatMessage {
  final String text;
  final String username;
  final bool isBot;

  ChatMessage({required this.text, required this.username, this.isBot = false});
}
