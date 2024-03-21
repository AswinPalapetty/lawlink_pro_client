import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class UserReviewReplyCard extends StatefulWidget {
  const UserReviewReplyCard({super.key});

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
            child: const Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text(
                        "Advocate",
                        style: TextStyle(fontSize: 18),
                      ),
                      Spacer(),
                      Text(
                        '01-12-2024',
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: EdgeInsets.all(20.0),
                  child: ExpandableText(
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                    expandText: 'show more',
                    collapseText: 'show less',
                    maxLines: 3,
                    linkColor: Color.fromARGB(255, 4, 90, 160),
                    style: TextStyle(
                        fontSize: 16, color: Color.fromARGB(255, 57, 57, 57)),
                  ),
                ),
              ],
            )));
  }
}
