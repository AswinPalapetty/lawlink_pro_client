import 'package:chat_gpt_sdk/chat_gpt_sdk.dart';
import 'package:dash_chat_2/dash_chat_2.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:lawlink_client/widgets/chatbot_scaffold.dart';

class ChatBot extends StatefulWidget {
  const ChatBot({super.key});

  @override
  State<ChatBot> createState() => _ChatBotState();
}

class _ChatBotState extends State<ChatBot> {

  final openAI = OpenAI.instance.build(
    token: '${dotenv.env['OPENAI_API_KEY']}',
    baseOption: HttpSetup(
      receiveTimeout: const Duration(seconds: 5),
    ),
    enableLog: true
  );


  final ChatUser _currentUser =
      ChatUser(id: '1', firstName: 'Aswin', lastName: 'P');

  final ChatUser _gptChatUser =
      ChatUser(id: '2', firstName: 'Chat', lastName: 'GPT');

  final List<ChatMessage> _messages = <ChatMessage>[];

  @override
  Widget build(BuildContext context) {
    return ChatBotScaffold(
      child: DashChat(
          currentUser: _currentUser,
          messageOptions: const MessageOptions(
            currentUserContainerColor: Colors.black,
            containerColor: Color.fromRGBO(
              0,
              166,
              126,
              1,
            ),
            textColor: Colors.white,
          ),
          onSend: (ChatMessage msg) {
            getChatResponse(msg);
          },
          messages: _messages),
    );
  }

  Future<void> getChatResponse(ChatMessage msg) async {
    setState(() {
      _messages.insert(0, msg);
    });

    List<Map<String, dynamic>> _messageHistory = _messages.reversed.map((msg) {
  if (msg.user == _currentUser) {
    return {
      'role': 'user',
      'content': msg.text,
    };
  } else {
    return {
      'role': 'assistant',
      'content': msg.text,
    };
  }
}).toList();

    final request = ChatCompleteText(model: GptTurbo0301ChatModel(), messages: _messageHistory, maxToken: 50);

    final response = await openAI.onChatCompletion(request: request);

    for (var element in response!.choices) {
      if (element.message != null) {
        setState(() {
          _messages.insert(
            0,
            ChatMessage(user: _gptChatUser, 
            createdAt: DateTime.now(),
            text: element.message!.content)
          );
        });
      }
    }
  }
}
