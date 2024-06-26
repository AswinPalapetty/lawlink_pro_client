import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:lawlink_client/utils/session.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class WriteReview extends StatefulWidget {
  const WriteReview({super.key});

  @override
  State<WriteReview> createState() => _WriteReviewState();
}

class _WriteReviewState extends State<WriteReview> {
  double rating = 0;
  String review = '';
  String? lawyerId;
  Map userData = {};

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    lawyerId = ModalRoute.of(context)?.settings.arguments as String;
    userData = await SessionManagement.getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            'Write Your Review',
            style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.of(context).pop(); // Pop twice to skip one page
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Center(
                  child: RatingBar.builder(
                      initialRating: 0,
                      minRating: 1,
                      direction: Axis.horizontal,
                      itemCount: 5,
                      itemPadding: const EdgeInsets.symmetric(horizontal: 4),
                      itemBuilder: (context, _) => const Icon(
                            Icons.star,
                            color: Colors.amber,
                          ),
                      onRatingUpdate: (rating) {
                        setState(() {
                          this.rating = rating;
                        });
                      }),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(25),
                child: TextField(
                  minLines: 2,
                  maxLines: 10,
                  decoration:
                      const InputDecoration(border: OutlineInputBorder()),
                  onChanged: (value) {
                    setState(() {
                      review = value;
                    });
                  },
                ),
              ),
              Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: onSubmit,
                        style: ElevatedButton.styleFrom(
                            backgroundColor:
                                const Color.fromARGB(255, 3, 37, 65),
                            shape: const RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius.all(Radius.circular(20))),
                            padding:
                                const EdgeInsets.symmetric(vertical: 15.0)),
                        child: const Text('Submit',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold)),
                      ))),
            ],
          ),
        ));
  }

  void onSubmit() {
    if (rating == 0) {
      showSnackBar('Rating is required');
      return;
    }

    if (review.isEmpty) {
      showSnackBar('Review is required');
      return;
    }

    // Proceed with submitting the review
    submitReview(rating, review);
  }

  void submitReview(double rating, String review) {
    final client = Supabase.instance.client;
    final userId = userData['userId'];
    Map ratingCount = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
    double overallRatingvalue = 0;
    int totalRatings = 0;
    late PostgrestList userReviews;
    late int reviewLength;

    if (userId == null ||
        userId.isEmpty ||
        lawyerId == null ||
        lawyerId!.isEmpty) {
      showSnackBar("Error occured.");
      return;
    }

    client.from('user_reviews').insert({
      'client_id': userId,
      'lawyer_id': lawyerId,
      'rating': rating,
      'message': review,
    }).then((response) async {
      showSnackBar("Successfully submitted your review.");

      userReviews = await client
          .from("user_reviews")
          .select()
          .eq("lawyer_id", lawyerId!);
      reviewLength = userReviews.length;
      for (int i = 0; i < userReviews.length; i++) {
        double rating = double.parse(userReviews[i]['rating']);
        if ([1, 2, 3, 4, 5].contains(rating)) {
          ratingCount[rating]++;
        }
      }
      ratingCount.forEach((rating, count) {
        overallRatingvalue += (rating * count).toDouble();
        totalRatings = (totalRatings + count).toInt();
      });

      if (totalRatings > 0) {
        overallRatingvalue =
            roundToTwoDecimalPlaces(overallRatingvalue /= totalRatings);
      }
      await client.from('lawyers').update({'rating':overallRatingvalue}).eq('user_id', lawyerId!);
      // ignore: use_build_context_synchronously
      Navigator.pushNamed(context, "/user_reviews", arguments: lawyerId);
    }).catchError((error) {
      print("error ===== $error");
      showSnackBar("Error occured.");
    });
  }

  double roundToTwoDecimalPlaces(double value) {
    return double.parse(value.toStringAsFixed(2));
  }

  void showSnackBar(String message) {
    final snackBar = SnackBar(
      content: Text(message),
      duration: const Duration(seconds: 3), // Adjust the duration as needed
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }
}
