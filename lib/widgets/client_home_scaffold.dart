import 'dart:math';

import 'package:flutter/material.dart';
import 'package:lawlink_client/utils/session.dart';

class ClientHomeScaffold extends StatefulWidget {
  const ClientHomeScaffold({super.key, this.child});

  final Widget? child;

  @override
  // ignore: library_private_types_in_public_api
  _ClientHomeScaffoldState createState() => _ClientHomeScaffoldState();
}

class _ClientHomeScaffoldState extends State<ClientHomeScaffold> {
  Map<String, String> userData = {};

  @override
  void initState() {
    super.initState();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    final data = await SessionManagement.getUserData();
    setState(() {
      userData = data;
    });
    print('name ========= ${userData['name']}');
  }

  Color getRandomColor() {
    final Random random = Random();
    return Color.fromARGB(
      255,
      random.nextInt(256),
      random.nextInt(256),
      random.nextInt(256),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        automaticallyImplyLeading: false,
        elevation: 3,
        bottom: const PreferredSize(preferredSize: Size(10, 10), child: Column()),
        shape: ContinuousRectangleBorder(borderRadius: BorderRadius.circular(10)),
        shadowColor: Colors.grey,
        title: Row(
          children: [
            CircleAvatar(
              radius: 25,
              backgroundColor: getRandomColor(),
              child: Text(
                '${userData['name']}'[0].toUpperCase(),
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
            ),

            const SizedBox(width: 10), // Space between avatar and text
            Text(
              'Hi, ${userData['name']}',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w400,
              ),
            ),
          ],
        ),

        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.sms_outlined),
                iconSize: 30),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: IconButton(
                onPressed: () {},
                icon: const Icon(Icons.notifications_none_outlined),
                iconSize: 30),
          )
        ],
      ),

      floatingActionButton: FloatingActionButton(
        onPressed: (){
          Navigator.pushNamed(context, '/add');
        },
        backgroundColor: Colors.blue[400],
        tooltip: "Talk to bot",
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(25)),
        child: const Icon(Icons.three_p, color: Colors.white,size: 26,)
      ),

      
      extendBodyBehindAppBar: true,
      body: Stack(
        children: [
          SafeArea(
            child: widget.child!,
          )
        ],
      ),
    );
  }
}
