import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lawlink_client/widgets/overall_rating.dart';
import 'package:lawlink_client/widgets/rating_progress_indicator.dart';
import 'package:lawlink_client/widgets/star_rating.dart';
import 'package:lawlink_client/widgets/user_review_card.dart';

class UserReviews extends StatefulWidget {
  const UserReviews({super.key});

  @override
  State<UserReviews> createState() => _UserReviewsState();
}

class _UserReviewsState extends State<UserReviews> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Reviews & Ratings',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                  "Ratings and reviews are verified and are from people who use same type of device that you use."),
              const SizedBox(height: 10),

              //overall ratings
              const OverallRating(),

              const StarRating(rating: 4.5,),

              const Text("(300)"),

              const SizedBox(height: 15),

              Padding(
                  padding:const EdgeInsets.only(top: 15.0, left: 5,bottom:15),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/write_review");
                    },
                    child: const Row(
                      children: [
                        Text(
                          "Write your review", // Align text to the left
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 22, // Increase font size to 24
                          ),
                        ),
                    
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  )),

              const SizedBox(height: 15),

              const UserReviewCard(),
            ],
          ),
        ),
      ),
    );
  }
}



