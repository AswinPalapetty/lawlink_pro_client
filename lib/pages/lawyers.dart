import 'package:flutter/material.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';

class Lawyers extends StatefulWidget {
  const Lawyers({super.key});

  @override
  State<Lawyers> createState() => _LawyersState();
}

class _LawyersState extends State<Lawyers> {
  @override
  Widget build(BuildContext context) {
    return ClientHomeScaffold(
      // child: Stack( // Wrap in Stack for positioning
      //   children: [
      //     SingleChildScrollView(
      //       child: Column(
      //         children: [
      //           Padding(
      //             padding: const EdgeInsets.all(10),
      //             child: Container(
      //               width: double.infinity,
      //               padding: const EdgeInsets.symmetric(horizontal: 16),
      //               child: TextField(
      //                 onChanged: (value) {},
      //                 decoration: const InputDecoration(
      //                   hintText: 'Search...',
      //                   hintStyle: TextStyle(color: Colors.grey),
      //                   border: InputBorder.none,
      //                   icon: Icon(Icons.search),
      //                 ),
      //               ),
      //             ),
      //           ),
      //           // Other widgets can be added here
      //         ],
      //       ),
      //     ),
      //     Positioned( // Positioned widget for fixed position
      //       top: 0, // Adjust top position as needed
      //       left: 0, // Adjust left position as needed
      //       right: 0, // Adjust right position as needed
      //       child: Padding(
      //         padding: const EdgeInsets.all(10),
      //         child: Container(
      //           decoration: BoxDecoration(
      //             color: Colors.grey[200],
      //             borderRadius: BorderRadius.circular(30),
      //           ),
      //           width: MediaQuery.of(context).size.width,
      //           padding: const EdgeInsets.symmetric(horizontal: 16),
      //           child: TextField(
      //             onChanged: (value) {},
      //             decoration: const InputDecoration(
      //               hintText: 'Search...',
      //               hintStyle: TextStyle(color: Colors.grey),
      //               border: InputBorder.none,
      //               icon: Icon(Icons.search),
      //             ),
      //           ),
      //         ),
      //       ),
      //     ),
      //   ],
      // ),
    );
  }
}
