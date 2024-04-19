import 'package:flutter/material.dart';
import 'package:lawlink_client/utils/session.dart';
import 'package:lawlink_client/widgets/chat_history.dart';
import 'package:lawlink_client/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ChatHistory extends StatefulWidget {
  const ChatHistory({super.key});

  @override
  State<ChatHistory> createState() => _ChatHistoryState();
}

class _ChatHistoryState extends State<ChatHistory> {
  bool isLoading = true;
  late Map<String, String> user;
  late List<Map<String, dynamic>> lawyers = [];
  @override
  void initState() {
    super.initState();
    fetchChats();
  }

  fetchChats() async {
    user = await SessionManagement.getUserData();
    final result = await Supabase.instance.client.from('message').select('user_from').eq('user_to', user['userId']!);
    for(var lawyerId in result){
      final lawyer = await Supabase.instance.client.from('lawyers').select().eq('user_id', lawyerId['user_from']).single();
      lawyers.add(lawyer);  
    }
    print(lawyers);
    // List<String> userIds = List<String>.from(result[0]['lawyers']);
    // for (var userId in userIds) {
    //   final lawyer = await Supabase.instance.client.from('lawyers').select().eq('user_id', userId).single();
    //   lawyer['practice_areas'] = lawyer['practice_areas'].join(',');
    //   print(lawyer);
    //   favoriteLawyers.add(lawyer);
    // }
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Chats',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
        body: isLoading ? const CustomProgressIndicator()
          : ListView.builder(
              itemCount: lawyers.length,
              itemBuilder: (context, index) {
                final data = lawyers[index];
                return ChatHistoryCard(
                  imageUrl: data['image'] ?? '',
                  latestMessage: '',
                  latestMessageTime: '',
                  name: data['name'] ?? '', // Replace 'name' with the actual field name
                  onTap: () {
                    Navigator.pushNamed(context, '/chat_page', arguments: {'lawyerId' : data['user_id'], 'lawyerName' : data['name']});
                  },
                );
              },
            ),
    );
  }
}