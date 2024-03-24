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
  String? selectedTimeSlot;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();

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
                icon: Icons.calendar_month,
                lawyerService: "Call charges: ",
                amount: "300",
                lawyerServiceInfo: "Talk to this lawyer\nby scheduling a call",
                buttonText: "Schedule",
                onPressed: () {
                  showModalBottomSheet(
                    context: context,
                    builder: (BuildContext context) {
                      return SingleChildScrollView(
                        // Allows scrolling if the content exceeds the screen height
                        child: Container(
                          padding: const EdgeInsets.all(20.0),
                          height: MediaQuery.of(context).size.height * 0.8,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Schedule Call',
                                style: TextStyle(
                                  fontSize: 24,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              const SizedBox(height: 20),
                              TextField(
                                controller: _dateController,
                                decoration: const InputDecoration(
                                    labelText: "Select Date",
                                    filled: true,
                                    suffixIcon:
                                        Icon(Icons.calendar_month_outlined),
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                                readOnly: true,
                                onTap: () {
                                  _SelectDate();
                                },
                              ),

                              const SizedBox(height: 20),
                              const SizedBox(height: 10),
                              Container(
                                height: 50,
                                color: const Color.fromARGB(255, 224, 228,
                                    221),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: DropdownButton<String>(
                                        underline: Container(
                                          height: 2,
                                          color: Colors.grey,
                                        ),
                                        items: const [
                                          DropdownMenuItem<String>(
                                            value: '9:00 AM',
                                            child: Text('9:00 AM'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: '10:00 AM',
                                            child: Text('10:00 AM'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: '12:00 AM',
                                            child: Text('12:00 AM'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: '13:00 AM',
                                            child: Text('13:00 AM'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: '14:00 AM',
                                            child: Text('14:00 AM'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: '15:00 AM',
                                            child: Text('15:00 AM'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: '16:00 AM',
                                            child: Text('16:00 AM'),
                                          ),
                                          DropdownMenuItem<String>(
                                            value: '17:00 AM',
                                            child: Text('17:00 AM'),
                                          ),
                                        ],
                                        onChanged: (String? value) {
                                          setState(() {
                                            selectedTimeSlot = value!;
                                          });
                                        },
                                        value: selectedTimeSlot,
                                        hint: Text(selectedTimeSlot == null
                                            ? 'Select Time Slot'
                                            : selectedTimeSlot!),
                                        icon: const Icon(null),
                                      ),
                                    ),
                                    const Icon(Icons.arrow_drop_down),
                                  ],
                                ),
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 10),
                              TextField(
                                controller: _hourController,
                                decoration: const InputDecoration(
                                    labelText: "Hours",
                                    filled: true,
                                    focusedBorder: OutlineInputBorder(
                                        borderSide:
                                            BorderSide(color: Colors.green))),
                              ),
                              const SizedBox(height: 20),
                              const SizedBox(height: 10),
                              Center(
                                child: ElevatedButton(
                                    style: ButtonStyle(
                                        iconColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        shape: MaterialStateProperty.all<
                                            RoundedRectangleBorder>(
                                          RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                                10.0), // Adjust border radius as needed
                                          ),
                                        ),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color.fromARGB(
                                                    255, 2, 130, 6))),
                                    onPressed: () {
                                      // Add your button onPressed logic here
                                    },
                                    child: const Text(' Request',
                                        style: TextStyle(
                                            color: Colors.white,
                                            fontSize: 15))),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
              Padding(
                padding: const EdgeInsets.only(top: 8.0),
                child: ViewLawyerCard(
                  icon: Icons.how_to_reg,
                  lawyerService: "Court sitting charges: ",
                  amount: "10,000",
                  lawyerServiceInfo: "Hire as\nyour lawyer",
                  buttonText: "Hire",
                  onPressed: () {
                    Navigator.pushNamed(context, '/hire_lawyer');
                  },
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

  // ignore: non_constant_identifier_names
  Future<void> _SelectDate() async {
    DateTime? picked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2024),
        lastDate: DateTime(2100));
    setState(() {
      _dateController.text = picked.toString().split(" ")[0];
    });
  }
}
