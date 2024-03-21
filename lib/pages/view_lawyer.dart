import 'package:flutter/material.dart';
import 'package:lawlink_client/widgets/ViewLawyer/practice_areas.dart';
import 'package:lawlink_client/widgets/ViewLawyer/view_lawyer_body.dart';
import 'package:lawlink_client/widgets/ViewLawyer/view_lawyer_card.dart';
import 'package:lawlink_client/widgets/ViewLawyer/view_lawyer_header.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';

class ViewLawyer extends StatefulWidget {
  const ViewLawyer({super.key});

  @override
  State<ViewLawyer> createState() => _ViewLawyerState();
}

class _ViewLawyerState extends State<ViewLawyer> {
  Color? iconColor = Colors.black;
  IconData? icon = Icons.thumb_up_alt_outlined;

  @override
  Widget build(BuildContext context) {
    return ClientHomeScaffold(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const ViewLawyerHeader(
                lawyerName: "Aswin P",
                aboutLawyer:
                    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
              ),
              ViewLawyerBody(
                aboutLawyer: "Lorem ipsum dolor sit amet,\n"
                    " consectetur adipiscing elit,\n",
                experience: "15",
                location: "Bangalore, Karnataka",
                onTap: () {
                  setState(() {
                    iconColor = iconColor == Colors.black
                        ? const Color.fromARGB(255, 2, 130, 6)
                        : Colors.black;
                    // ignore: unrelated_type_equality_checks
                    icon = icon == Icons.thumb_up_alt_outlined
                        ? Icons.thumb_up_alt
                        : Icons.thumb_up_alt_outlined;
                  });
                },
                child: Icon(icon, color: iconColor),
              ),
              ViewLawyerCard(
                lawyerService: "Call charges: ",
                amount: "300",
                lawyerServiceInfo: "Talk to this lawyer\nby scheduling a call",
                buttonText: "Schedule",
                onPressed: () {},
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ViewLawyerCard(
                  lawyerService: "Court sitting charges: ",
                  amount: "10,000",
                  lawyerServiceInfo: "Register for\ncourt sitting",
                  buttonText: "Register",
                  onPressed: () {},
                ),
              ),
              const Padding(
                padding: EdgeInsets.only(top: 10.0, left: 5, bottom: 9),
                child: Text(
                  "Practice areas", // Align text to the left
                  style: TextStyle(
                    fontWeight: FontWeight.bold, // Make the text bold
                    fontSize: 22, // Increase font size to 24
                  ),
                ),
              ),
              const PracticeAreas(
                practiceArea: "Consumer protection",
              ),
              const PracticeAreas(
                practiceArea: "Consumer protection",
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20, bottom: 20),
                child: Container(
                  height: 1,
                  color: Colors.grey, // Set the color of the line
                ),
              ),
              Padding(
                  padding:
                      const EdgeInsets.only(top: 10.0, left: 5, bottom: 30),
                  child: GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, "/user_reviews");
                    },
                    child: const Row(
                      children: [
                        Text(
                          "User Reviews(199)", // Align text to the left
                          style: TextStyle(
                            fontWeight: FontWeight.bold, // Make the text bold
                            fontSize: 22, // Increase font size to 24
                          ),
                        ),
                        Icon(Icons.arrow_forward_ios)
                      ],
                    ),
                  )),
            ],
          ),
        ),
      ),
    );
  }
}
