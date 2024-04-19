import 'package:flutter/material.dart';
import 'package:lawlink_client/utils/session.dart';
import 'package:lawlink_client/widgets/ViewLawyer/practice_areas.dart';
import 'package:lawlink_client/widgets/ViewLawyer/view_lawyer_body.dart';
import 'package:lawlink_client/widgets/ViewLawyer/view_lawyer_card.dart';
import 'package:lawlink_client/widgets/ViewLawyer/view_lawyer_header.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';
import 'package:lawlink_client/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

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

  late String lawyerId;
  late PostgrestList lawyerData, totalReviews;
  bool isLoading = true;
  late String aboutLawyer;
  late int reviewLength;
  late Map<String, String> userData;

  @override
  void initState() {
    super.initState();
    // Don't fetch data in initState(), move it to didChangeDependencies()
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data when dependencies change (context is available)
    fetchLawyer();
  }

  fetchLawyer() async {
    lawyerId = ModalRoute.of(context)?.settings.arguments as String;
    userData = await SessionManagement.getUserData();
    lawyerData = await Supabase.instance.client
        .from('lawyers')
        .select()
        .eq('user_id', lawyerId);
    aboutLawyer =
        "Registration No: ${lawyerData[0]['registration_no']}\n Education: ";
    for (var education in lawyerData[0]['education']) {
      aboutLawyer += "$education\n";
    }
    totalReviews = await Supabase.instance.client
        .from("user_reviews")
        .select()
        .eq("lawyer_id", lawyerData[0]['user_id']);
    reviewLength = totalReviews.length;
    final result = await Supabase.instance.client
        .from('favourites')
        .select()
        .eq('client_id', userData['userId']!);
    if (result.isNotEmpty) {
      final List<dynamic> lawyers = result[0]['lawyers'];
      if (lawyers.contains(lawyerData[0]['user_id'])) {
        setState(() {
          iconColor = Colors.green;
          icon = Icons.thumb_up_alt;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  addToFavourites() async {
    final existingRow = await Supabase.instance.client
        .from('favourites')
        .select()
        .eq('client_id', userData['userId']!);
    if (existingRow.isEmpty) {
      await Supabase.instance.client.from('favourites').insert({
        'client_id': userData['userId']!,
        'lawyers': [lawyerId]
      });
      setState(() {
        iconColor = Colors.green;
        icon = Icons.thumb_up_alt;
      });
    } else if (existingRow.isNotEmpty) {
      final existingLawyers = List<String>.from(existingRow[0]['lawyers']);
      if (!existingLawyers.contains(lawyerId)) {
        existingLawyers.add(lawyerId);
        await Supabase.instance.client.from('favourites').update({
          'lawyers': existingLawyers,
        }).eq('client_id', userData['userId']!);
        setState(() {
          iconColor = Colors.green;
          icon = Icons.thumb_up_alt;
        });
      } else {
        final existingLawyers = List<String>.from(existingRow[0]['lawyers']);
        existingLawyers.remove(lawyerId);
        await Supabase.instance.client.from('favourites').update({
          'lawyers': existingLawyers,
        }).eq('client_id', userData['userId']!);
        setState(() {
          iconColor = Colors.black;
          icon = Icons.thumb_up_alt_outlined;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClientHomeScaffold(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(15.0),
          child: isLoading
              ? const CustomProgressIndicator()
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ViewLawyerHeader(
                      lawyerName: lawyerData[0]['name'],
                      aboutLawyer: lawyerData[0]['description'],
                      child: CircleAvatar(
                        backgroundColor: Colors.black,
                        radius: 30,
                        backgroundImage: lawyerData[0]['image'] != null &&
                                lawyerData[0]['image'] != ''
                            ? NetworkImage(lawyerData[0]['image'])
                            : null,
                        child: lawyerData[0]['image'] != null &&
                                lawyerData[0]['image'] != ''
                            ? null
                            : const Icon(Icons.account_circle,
                                color: Colors.white, size: 60),
                      ),
                    ),
                    ViewLawyerBody(
                      aboutLawyer: aboutLawyer,
                      experience: "15",
                      location: lawyerData[0]['location'],
                      onTap: () {
                        addToFavourites();
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
                      amount: lawyerData[0]['call_charge'],
                      lawyerServiceInfo:
                          "Talk to this lawyer\nby scheduling a call",
                      buttonText: "Schedule",
                      onPressed: () {
                        showModalBottomSheet(
                          context: context,
                          builder: (BuildContext context) {
                            return SingleChildScrollView(
                              // Allows scrolling if the content exceeds the screen height
                              child: Container(
                                padding: const EdgeInsets.all(20.0),
                                height:
                                    MediaQuery.of(context).size.height * 0.8,
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
                                          suffixIcon: Icon(
                                              Icons.calendar_month_outlined),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.green))),
                                      readOnly: true,
                                      onTap: () {
                                        _SelectDate();
                                      },
                                    ),
                                    const SizedBox(height: 20),
                                    const SizedBox(height: 10),
                                    Container(
                                      height: 50,
                                      color: const Color.fromARGB(
                                          255, 224, 228, 221),
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
                                              hint: Text(
                                                  selectedTimeSlot == null
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
                                              borderSide: BorderSide(
                                                  color: Colors.green))),
                                    ),
                                    const SizedBox(height: 20),
                                    const SizedBox(height: 10),
                                    Center(
                                      child: ElevatedButton(
                                          style: ButtonStyle(
                                              iconColor: MaterialStateProperty
                                                  .all<Color>(Colors.white),
                                              shape: MaterialStateProperty.all<
                                                  RoundedRectangleBorder>(
                                                RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0), // Adjust border radius as needed
                                                ),
                                              ),
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
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
                        amount: lawyerData[0]['sitting_charge'],
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
                    // const PracticeAreas(
                    //   practiceArea: "Consumer protection",
                    // ),
                    ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: lawyerData[0]['practice_areas'].length,
                      itemBuilder: (context, index) {
                        final practiceArea =
                            lawyerData[0]['practice_areas'][index];
                        return PracticeAreas(practiceArea: practiceArea);
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20, bottom: 20),
                      child: Container(
                        height: 1,
                        color: Colors.grey, // Set the color of the line
                      ),
                    ),
                    Padding(
                        padding: const EdgeInsets.only(
                            top: 10.0, left: 5, bottom: 30),
                        child: GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, "/user_reviews",
                                arguments: lawyerData[0]['user_id']);
                          },
                          child: Row(
                            children: [
                              Text(
                                "User Reviews($reviewLength)", // Align text to the left
                                style: const TextStyle(
                                  fontWeight:
                                      FontWeight.bold, // Make the text bold
                                  fontSize: 22, // Increase font size to 24
                                ),
                              ),
                              const Icon(Icons.arrow_forward_ios)
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
