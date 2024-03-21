import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:lawlink_client/widgets/star_rating.dart';
import 'package:lawlink_client/widgets/user_review_reply_card.dart';

class UserReviewCard extends StatefulWidget {
  const UserReviewCard({super.key});

  @override
  State<UserReviewCard> createState() => _UserReviewCardState();
}

class _UserReviewCardState extends State<UserReviewCard> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Row(
              children: [
                CircleAvatar(
                    backgroundImage: AssetImage('assets/images/user.jpg')),
                SizedBox(width: 5),
                Text("Aswin")
              ],
            ),
            IconButton(onPressed: () {}, icon: const Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(height: 5),
        const Row(
          children: [
            StarRating(rating: 4),
            SizedBox(width: 10),
            Text('01-12-2024')
          ],
        ),
        const SizedBox(height: 10),
        const ExpandableText(
          "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
          expandText: 'show more',
          collapseText: 'show less',
          maxLines: 3,
          linkColor: Colors.blue,
          style:
              TextStyle(fontSize: 16, color: Color.fromARGB(255, 57, 57, 57)),
        ),

        const SizedBox(height: 10),

        const UserReviewReplyCard()
      ],
    );
  }
}
