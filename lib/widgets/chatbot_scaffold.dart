import 'package:flutter/material.dart';

class ChatBotScaffold extends StatefulWidget {
  const ChatBotScaffold({super.key, this.child});

  final Widget? child;

  @override
  State<ChatBotScaffold> createState() => _ChatBotScaffoldState();
}

class _ChatBotScaffoldState extends State<ChatBotScaffold> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 3,
        bottom:
            const PreferredSize(preferredSize: Size(10, 10), child: Column()),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: Colors.grey,
        title: const Text(
          'Talk to Bot',
          style: TextStyle(
            color: Colors.black,
            fontWeight: FontWeight.w600
          ),
        ),
      ),

      body: SafeArea(
            child: widget.child!,
          ),
    );
  }
}
