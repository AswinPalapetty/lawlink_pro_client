import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';
import 'package:lawlink_client/widgets/overall_rating.dart';
import 'package:lawlink_client/widgets/progress_indicator.dart';
import 'package:lawlink_client/widgets/star_rating.dart';
import 'package:lawlink_client/widgets/user_review_card.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class UserReviews extends StatefulWidget {
  const UserReviews({super.key});

  @override
  State<UserReviews> createState() => _UserReviewsState();
}

class _UserReviewsState extends State<UserReviews> {
  late PostgrestList userReviews, lawyerData;
  late int reviewLength;
  late String lawyerId;
  bool isLoading = true;
  Map ratingCount = {5: 0, 4: 0, 3: 0, 2: 0, 1: 0};
  double overallRatingvalue = 0;
  int totalRatings = 0;

  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    fetchUserReviews();
  }

  fetchUserReviews() async {
    lawyerId = ModalRoute.of(context)?.settings.arguments as String;
    userReviews = await Supabase.instance.client
        .from("user_reviews")
        .select()
        .eq("lawyer_id", lawyerId);
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
      overallRatingvalue = roundToTwoDecimalPlaces(overallRatingvalue /= totalRatings);
    }
    lawyerData = await Supabase.instance.client
        .from("lawyers")
        .select()
        .eq("user_id", lawyerId);
    setState(() {
      isLoading = false;
    });

    print(ratingCount[1]/reviewLength);
  }

  double roundToTwoDecimalPlaces(double value) {
  return double.parse(value.toStringAsFixed(2));
}

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
          child: isLoading
              ? const CustomProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                        "Ratings and reviews are verified and are from people who use same type of device that you use."),
                    const SizedBox(height: 10),

                    //overall ratings
                    OverallRating(
                      overallRatingvalue: overallRatingvalue.toString(),
                      rating1: ratingCount[1].toDouble(),
                      rating2: ratingCount[2].toDouble(),
                      rating3: ratingCount[3].toDouble(),
                      rating4: ratingCount[4].toDouble(),
                      rating5: ratingCount[5].toDouble(),
                      reviewLength: reviewLength,
                    ),

                    StarRating(
                      rating: overallRatingvalue,
                    ),

                    Text("($reviewLength)"),

                    const SizedBox(height: 15),

                    Padding(
                        padding: const EdgeInsets.only(
                            top: 15.0, left: 5, bottom: 15),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(
                                context,
                                "/write_review",
                                arguments: lawyerId
                              );
                          },
                          child: const Row(
                            children: [
                              Text(
                                "Write your review", // Align text to the left
                                style: TextStyle(
                                  fontWeight:
                                      FontWeight.bold, // Make the text bold
                                  fontSize: 22, // Increase font size to 24
                                ),
                              ),
                              Icon(Icons.arrow_forward_ios)
                            ],
                          ),
                        )),

                    const SizedBox(height: 15),

                    reviewLength != 0
                        ? Column(
                            children: userReviews.map((review) {
                              return FutureBuilder(
                                future: fetchClientData(review['client_id']),
                                builder: (context, snapshot) {
                                  if (snapshot.connectionState ==
                                      ConnectionState.waiting) {
                                    // Return a placeholder while data is being fetched
                                    return const CustomProgressIndicator();
                                  } else if (snapshot.hasError) {
                                    // Return an error message if data fetching fails
                                    return Text('Error: ${snapshot.error}');
                                  } else {
                                    // Return the UserReviewCard when data is available
                                    final clientData = snapshot.data;
                                    return UserReviewCard(
                                      image: clientData?['image'] ?? '',
                                      clientName: clientData?[
                                          'name'], // Replace 'name' with the appropriate field
                                      date:
                                          formatIsoString(review['created_at']),
                                      message: review['message'],
                                      rating: double.parse(review['rating']),
                                      lawyerName: lawyerData[0]['name'],
                                      replyDate:
                                          review['reply_created_at'] != null
                                              ? formatIsoString(
                                                  review['reply_created_at'])
                                              : null,
                                      replyMessage: review['reply'],
                                    );
                                  }
                                },
                              );
                            }).toList(),
                          )
                        : const Padding(
                            padding: EdgeInsets.only(top: 30.0),
                            child: Center(
                              child: Text(
                                "No reviews found.", // Align text to the left
                                style: TextStyle(
                                  color: Color.fromARGB(255, 75, 75, 75),
                                  fontWeight:
                                      FontWeight.w400, // Make the text bold
                                  fontSize: 22, // Increase font size to 24
                                ),
                              ),
                            ),
                          ),
                  ],
                ),
        ),
      ),
    );
  }

  String formatIsoString(String isoString) {
    // Parse ISO 8601 string to DateTime object
    DateTime dateTime = DateTime.parse(isoString);

    // Format DateTime object to 'dd-MM-yyyy' format
    String formattedDate = DateFormat('dd-MM-yyyy').format(dateTime);

    return formattedDate;
  }

  Future<Map<String, dynamic>> fetchClientData(String clientId) async {
    final response = await Supabase.instance.client
        .from('clients')
        .select()
        .eq('user_id', clientId)
        .single();
    return response;
  }
}
