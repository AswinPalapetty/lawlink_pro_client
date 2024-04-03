import 'package:flutter/material.dart';
import 'package:lawlink_client/widgets/rating_progress_indicator.dart';

class OverallRating extends StatelessWidget {
  const OverallRating({
    super.key, required this.rating1, required this.rating2, required this.rating3, required this.rating4, required this.rating5, required this.reviewLength, required this.overallRatingvalue
  });

  final double rating1, rating2, rating3, rating4, rating5;
  final int reviewLength;
  final String overallRatingvalue;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
         Expanded(
            flex: 3,
            child: Text(overallRatingvalue, style: const TextStyle(fontSize: 50))),
        Expanded(
            flex: 7,
            child: Column(
              children: [
                RatingProgressIndicator(text: '5',value: reviewLength != 0 ? rating5/reviewLength : 0),
                RatingProgressIndicator(text: '4',value: reviewLength != 0 ? rating4/reviewLength : 0),
                RatingProgressIndicator(text: '3',value: reviewLength != 0 ? rating3/reviewLength : 0),
                RatingProgressIndicator(text: '2',value: reviewLength != 0 ? rating2/reviewLength : 0),
                RatingProgressIndicator(text: '1',value: reviewLength != 0 ? rating1/reviewLength : 0)
              ],
            )),
      ],
    );
  }
}