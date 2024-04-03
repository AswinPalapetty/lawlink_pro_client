import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class UserReviewReplyCard extends StatefulWidget {
  const UserReviewReplyCard({super.key, required this.lawyerName, required this.replyDate, required this.replyMessage});

  final String lawyerName,replyDate,replyMessage;

  @override
  State<UserReviewReplyCard> createState() => _UserReviewReplyCardState();
}

class _UserReviewReplyCardState extends State<UserReviewReplyCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Shadow color
              spreadRadius: 3, // Spread radius
              blurRadius: 10, // Blur radius
              //offset: const Offset(5, 5), // Offset in x and y direction
            ),
          ],
        ),
        child: Card(
            color: Colors.grey,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        'Adv. ${widget.lawyerName}',
                        style: const TextStyle(fontSize: 18),
                      ),
                      const Spacer(),
                      Text(
                        widget.replyDate,
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: ExpandableText(
                    widget.replyMessage,
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 3,
                    linkColor: const Color.fromARGB(255, 4, 90, 160),
                    style: const TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 57, 57, 57)),
                  ),
                ),
              ],
            )));
  }
}
