import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:lawlink_client/widgets/star_rating.dart';
import 'package:lawlink_client/widgets/user_review_reply_card.dart';

class UserReviewCard extends StatefulWidget {
  const UserReviewCard(
      {super.key,
      required this.clientName,
      required this.message, required this.date, required this.image, required this.rating, this.lawyerName, this.replyDate, this.replyMessage});
  final String clientName, message, date;
  final String image;
  final double rating;
  final String? lawyerName,replyDate, replyMessage;

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
            Row(
              children: [
                CircleAvatar(
                  backgroundColor: Colors.black,
                  radius: 20,
                  backgroundImage: widget.image != ''
                      ? AssetImage(widget.image)
                      : null,
                  child: widget.image != ''
                      ? null
                      : const Icon(Icons.account_circle,
                          color: Colors.white, size: 40),
                ),
                const SizedBox(width: 5),
                Text(widget.clientName)
              ],
            ),
            IconButton(onPressed: () {
              print("${widget.replyDate} ${widget.replyMessage}");
            }, icon: const Icon(Icons.more_vert)),
          ],
        ),
        const SizedBox(height: 5),
        Row(
          children: [
            StarRating(rating: widget.rating),
            const SizedBox(width: 10),
            Text(widget.date)
          ],
        ),
        const SizedBox(height: 10),
        Align( // Align content to the left
          alignment: Alignment.centerLeft,
          child: ExpandableText(
            widget.message,
            expandText: 'show more',
            collapseText: 'show less',
            maxLines: 3,
            linkColor: Colors.blue,
            style: const TextStyle(
                fontSize: 16, color: Color.fromARGB(255, 57, 57, 57)),
          ),
        ),
        const SizedBox(height: 10),
        (widget.replyMessage != null && widget.replyDate != null) ? 
        UserReviewReplyCard(
          lawyerName: widget.lawyerName!,
          replyDate: widget.replyDate!,
          replyMessage: widget.replyMessage!,
        ) : const SizedBox(height: 10)
      ],
    );
  }
}
