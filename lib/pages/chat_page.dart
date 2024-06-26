import 'dart:async';
import 'package:flutter/material.dart';
import 'package:lawlink_client/utils/message.dart';
import 'package:lawlink_client/utils/session.dart';
import 'package:lawlink_client/utils/chat_constants.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:timeago/timeago.dart';

/// Page to chat with someone.
///
/// Displays chat bubbles as a ListView and TextField to enter new chat.
class ChatPage extends StatefulWidget {
  const ChatPage({super.key});

  static Route<void> route() {
    return MaterialPageRoute(
      builder: (context) => const ChatPage(),
    );
  }

  @override
  State<ChatPage> createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  late final Stream<List<Message>> _messagesStream;
  Map<String, String> _profileCache = {};
  late String lawyerId;
  late String lawyerName;
  late String userId;

  @override
  void initState() {
    loadData();
    super.initState();
  }

  Future<void> loadData() async {
    final userData = await SessionManagement.getUserData();
    userId = userData['userId']!;
    // ignore: use_build_context_synchronously
    final args =
        ModalRoute.of(context)!.settings.arguments as Map<String, dynamic>;
    lawyerId = args['lawyerId'];
    lawyerName = args['lawyerName'];
    final messagesStream = supabase
        .from('message')
        .stream(primaryKey: ['id'])
        .inFilter('user_from', [lawyerId, userId])
        .order('created_at')
        .map((maps) => maps
            .map((map) => Message.fromMap(
                map: map, myUserId: userId))
            .toList());
    setState(() {
      _messagesStream = messagesStream;
    });
  }

  Future<void> _loadProfileCache() async {
    if (_profileCache['id'] == lawyerId) {
      return;
    }
    setState(() {
      _profileCache['id'] = lawyerId;
      _profileCache['name'] = lawyerName;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(lawyerName)),
      body: StreamBuilder<List<Message>>(
        stream: _messagesStream,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            final messages = snapshot.data!;
            return Column(
              children: [
                Expanded(
                  child: messages.isEmpty
                      ? const Center(
                          child: Text('Start your conversation now :)'),
                        )
                      : ListView.builder(
                          reverse: true,
                          itemCount: messages.length,
                          itemBuilder: (context, index) {
                            final message = messages[index];
                            _loadProfileCache();

                            if (message.user_to == lawyerId ||
                                message.user_to == userId) {
                              return _ChatBubble(
                                message: message,
                                profile: _profileCache,
                              );
                            }
                            else{
                              return const SizedBox(height: 1);
                            }
                          },
                        ),
                ),
                _MessageBar(lawyerId: lawyerId),
              ],
            );
          } else {
            return preloader;
          }
        },
      ),
    );
  }
}

/// Set of widget that contains TextField and Button to submit message
class _MessageBar extends StatefulWidget {
  _MessageBar({
    Key? key, required this.lawyerId
  }) : super(key: key);

  final String lawyerId;

  @override
  State<_MessageBar> createState() => _MessageBarState(lawyerId);
}

class _MessageBarState extends State<_MessageBar> {
  late final TextEditingController _textController;
  String lawyerId;

  _MessageBarState(this.lawyerId);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.grey[200],
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Row(
            children: [
              Expanded(
                child: TextFormField(
                  keyboardType: TextInputType.text,
                  maxLines: null,
                  autofocus: true,
                  controller: _textController,
                  decoration: const InputDecoration(
                    hintText: 'Type a message',
                    border: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: EdgeInsets.all(8),
                  ),
                ),
              ),
              TextButton(
                onPressed: () => _submitMessage(lawyerId),
                child: const Text('Send'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    _textController = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  void _submitMessage(String lawyerId) async {
    final userData = await SessionManagement.getUserData();
    final text = _textController.text;
    if (text.isEmpty) {
      return;
    }
    _textController.clear();
    try {
      await supabase.from('message').insert({
        'user_from': userData['userId']!,
        'user_to': lawyerId,
        'content': text,
      });
    } on PostgrestException catch (error) {
      context.showErrorSnackBar(message: error.message);
    } catch (_) {
      context.showErrorSnackBar(message: unexpectedErrorMessage);
    }
  }
}

// ignore: must_be_immutable
class _ChatBubble extends StatelessWidget {
  _ChatBubble({Key? key, required this.message, required this.profile})
      : super(key: key);

  final Message message;
  Map<String, String> profile = {};

  @override
  Widget build(BuildContext context) {
    List<Widget> chatContents = [
      if (message.user_from == profile['id'])
      const SizedBox(width: 12),
      Flexible(
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 8,
            horizontal: 12,
          ),
          decoration: BoxDecoration(
            color: message.isMine
                ? const Color.fromARGB(255, 10, 63, 105)
                : const Color.fromARGB(255, 1, 3, 5),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Text(message.content, style:const TextStyle(color: Colors.white),),
        ),
      ),
      const SizedBox(width: 12),
      Text(format(message.created_at, locale: 'en_short')),
      const SizedBox(width: 60),
    ];
    if (message.isMine) {
      chatContents = chatContents.reversed.toList();
    }
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 18),
      child: Row(
        mainAxisAlignment:
            message.isMine ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: chatContents,
      ),
    );
  }
}
