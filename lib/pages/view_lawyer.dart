import 'package:flutter/material.dart';
import 'package:flutter_phone_direct_caller/flutter_phone_direct_caller.dart';
import 'package:intl/intl.dart';
import 'package:lawlink_client/utils/session.dart';
import 'package:lawlink_client/widgets/ViewLawyer/practice_areas.dart';
import 'package:lawlink_client/widgets/ViewLawyer/view_lawyer_body.dart';
import 'package:lawlink_client/widgets/ViewLawyer/view_lawyer_card.dart';
import 'package:lawlink_client/widgets/ViewLawyer/view_lawyer_header.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';
import 'package:lawlink_client/widgets/progress_indicator.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ViewLawyer extends StatefulWidget {
  const ViewLawyer({super.key});

  @override
  State<ViewLawyer> createState() => _ViewLawyerState();
}

class _ViewLawyerState extends State<ViewLawyer> {
  Color? iconColor = Colors.black;
  IconData? icon = Icons.thumb_up_alt_outlined;
  String? selectedTimeSlot, description;
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _hourController = TextEditingController();

  late String lawyerId;
  late PostgrestList lawyerData, totalReviews, scheduledCall, caseBooked;
  bool isLoading = true;
  bool callRequest = false,
      caseRequest = false,
      callApproved = false,
      caseApproved = false,
      callAmountpaid = false;
  late String aboutLawyer;
  late int reviewLength;
  late Map<String, String> userData;
  late List<dynamic> timeSlots;
  late List<Map<String, dynamic>> callDetails;

  late Razorpay _razorpay;
  late Map<String, dynamic> options;

  @override
  void initState() {
    _razorpay = Razorpay();

    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

    super.initState();
    // Don't fetch data in initState(), move it to didChangeDependencies()
  }

  @override
  void dispose() {
    _razorpay.clear();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Fetch data when dependencies change (context is available)
    fetchLawyer();
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) async {
    await Supabase.instance.client
        .from("call_booking")
        .update({'amount_paid': true})
        .eq("lawyer_id", lawyerId)
        .eq("client_id", userData['userId']!)
        .eq("amount_paid", false);
    showSnackbar(context, 'Payment successful!');
    setState(() {
      isLoading = false;
      callAmountpaid = true;
    });
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    showSnackbar(context, 'Payment failed!');
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    showSnackbar(context, 'Payment successful!');
  }

  void showSnackbar(BuildContext context, String message) {
    final snackBar = SnackBar(content: Text(message));
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  bool checkCallTime(String dateStr, String slot, int id, int hours) {
    try {
      // Get the current date and time
      DateTime now = DateTime.now();
      print("now == $now");

      // Parse the provided date string
      DateTime date = DateFormat('yyyy-MM-dd').parse(dateStr);
      print("date == $date");

      // Parse the slot time
      DateTime slotTime = DateFormat('hh:mm a').parse(slot);
      print("slotTime == $slotTime");

      DateTime combinedDateTime = DateTime(
        date.year,
        date.month,
        date.day,
        slotTime.hour,
        slotTime.minute,
      );
      print("combined time == $combinedDateTime");
      // Calculate the end time based on the provided hours
      DateTime endTime = combinedDateTime.add(Duration(hours: hours));
      print("endTime == $endTime");

      // Check if current date and time is equal to date and slot
      if (now.year == combinedDateTime.year &&
          now.month == combinedDateTime.month &&
          now.day == combinedDateTime.day &&
          now.hour == combinedDateTime.hour &&
          now.minute == combinedDateTime.minute) {
        print("success 1");
        return true;
      }

      print("Now is after  ==== ${now.isAfter(combinedDateTime)}");
      print("Now is before  ==== ${now.isBefore(endTime)}");

      // Check if current date and time is within hours from date and slot
      if (now.isAfter(combinedDateTime) && now.isBefore(endTime)) {
        print("success 2");
        return true;
      }

      if(now.isAfter(endTime)) {
        Future.delayed(Duration.zero, () {
          deleteCall(id);
        });
        return false;
      }

      return false;
    } catch (e) {
      print('Error parsing date or slot time: $e');
      return false;
    }
  }

  deleteCall(int id) async{
    await Supabase.instance.client.from('call_booking').delete().eq('id', id);
    final snackBar = SnackBar(
          content: const Text(
              'Call time has ended. Now you can schedule new call.'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {},
          ));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      Navigator.pushNamed(context, "/view_lawyer", arguments: lawyerId);
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
    final response = await Supabase.instance.client
        .from('time_slots')
        .select('slots')
        .eq('lawyer_id', lawyerId);
    if (response.isNotEmpty) {
      setState(() {
        timeSlots = response[0]['slots'];
      });
    } else {
      timeSlots = [];
    }
    scheduledCall = await Supabase.instance.client
        .from('call_booking')
        .select()
        .eq('client_id', userData['userId']!)
        .eq('lawyer_id', lawyerId);
    if (scheduledCall.isNotEmpty) {
      setState(() {
        callRequest = true;
        //callDetails = await Supabase.instance.client.from('call_booking').select().eq('client_id', userData['userId']!).eq('lawyer_id', lawyerId);
      });
      if (scheduledCall[0]['accepted']) {
        setState(() {
          callApproved = true;
        });
        if (scheduledCall[0]['amount_paid']) {
          setState(() {
            callAmountpaid = true;
          });
        }
      }
    }
    caseBooked = await Supabase.instance.client
        .from('lawyer_booking')
        .select()
        .eq('client_id', userData['userId']!)
        .eq('lawyer_id', lawyerId);
    if (caseBooked.isNotEmpty) {
      setState(() {
        caseRequest = true;
      });
      if (caseBooked[0]['accepted']) {
        setState(() {
          caseApproved = true;
        });
      }
    }
    setState(() {
      isLoading = false;
    });
  }

  makePayment(String description, String amount, {String hours = "1"}) async {
    final doubleAmount = double.parse(amount);
    final doubleHours = double.parse(hours);
    options = {
      'key': 'rzp_test_hRuJXY7QtiyiLU',
      'amount':
          doubleAmount * 100 * doubleHours, //in the smallest currency sub-unit.
      'name': lawyerData[0]['name'],
      'description': description,
      'timeout': 120, // in seconds
      'prefill': {
        'contact': lawyerData[0]['phone'],
        'email': lawyerData[0]['email']
      }
    };
    _razorpay.open(options);
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
                      icon: callRequest
                          ? callApproved
                              ? (callAmountpaid
                                  ? Icons.call
                                  : Icons.payments_outlined)
                              : Icons.grid_view
                          : Icons.calendar_month,
                      lawyerService: "Call charges: ",
                      amount: lawyerData[0]['call_charge'],
                      lawyerServiceInfo: callRequest
                          ? (callApproved
                              ? (callAmountpaid
                                  ? "Call request approved.\nCall can be made\non selected time period."
                                  : "Call request approved.\nMake payment.")
                              : "Waiting for lawyer\napproval")
                          : "Talk to this lawyer\nby scheduling a call",
                      buttonText: callRequest
                          ? (callApproved
                              ? (callAmountpaid ? " Call" : " Pay")
                              : 'View')
                          : "Schedule",
                      onPressed: () async {
                        if (callRequest) {
                          if (callApproved && !callAmountpaid) {
                            makePayment("Make payment to schedule call",
                                lawyerData[0]['call_charge']);
                          } else {
                            if (checkCallTime(
                                scheduledCall[0]['date'],
                                scheduledCall[0]['time_slot'],
                                scheduledCall[0]['id'],
                                int.parse(scheduledCall[0]['hours']))) {
                                  await FlutterPhoneDirectCaller.callNumber(lawyerData[0]['phone']);

                            } else {
                              showModalBottomSheet(
                                context: context,
                                builder: (BuildContext context) {
                                  return SingleChildScrollView(
                                    // Allows scrolling if the content exceeds the screen height
                                    child: SizedBox(
                                      width: MediaQuery.of(context).size.width *
                                          1, // Set desired width
                                      child: Container(
                                        padding: const EdgeInsets.all(20.0),
                                        child: Center(
                                          child: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              const Text(
                                                'You can only make call on the selected time period',
                                                style: TextStyle(
                                                  fontSize: 24,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                              const SizedBox(height: 20),
                                              Text(
                                                'Matter: ${scheduledCall[0]['description']}',
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                              const SizedBox(height: 2),
                                              Text(
                                                'Date and time: ${scheduledCall[0]['date']} ${scheduledCall[0]['time_slot']}(${scheduledCall[0]['hours']}hour)',
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                              const SizedBox(height: 10),
                                              Text(
                                                'Amount paid: $callAmountpaid',
                                                style: const TextStyle(
                                                    fontSize: 18),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              );
                            }
                          }
                        } else {
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
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                items: timeSlots.isNotEmpty
                                                    ? timeSlots.map<
                                                            DropdownMenuItem<
                                                                String>>(
                                                        (dynamic slot) {
                                                        return DropdownMenuItem<
                                                            String>(
                                                          value:
                                                              slot.toString(),
                                                          child: Text(
                                                              slot.toString()),
                                                        );
                                                      }).toList()
                                                    : [
                                                        const DropdownMenuItem<
                                                            String>(
                                                          value:
                                                              'no_slots_found',
                                                          child: Text(
                                                            'No Slots Found',
                                                            style: TextStyle(
                                                                color: Colors
                                                                    .grey),
                                                          ),
                                                        ),
                                                      ],
                                                onChanged: (String? value) {
                                                  if (value !=
                                                      'no_slots_found') {
                                                    setState(() {
                                                      selectedTimeSlot = value!;
                                                    });
                                                  }
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
                                      TextField(
                                        minLines: 2,
                                        maxLines: 10,
                                        onChanged: (value) {
                                          setState(() {
                                            description = value;
                                          });
                                        },
                                        decoration: const InputDecoration(
                                            border: OutlineInputBorder(),
                                            hintText:
                                                'Give an explanation about the matter.',
                                            labelText: 'Message',
                                            alignLabelWithHint: true),
                                      ),
                                      const SizedBox(height: 20),
                                      Center(
                                        child: ElevatedButton(
                                            style: ButtonStyle(
                                                iconColor: MaterialStateProperty
                                                    .all<Color>(Colors.white),
                                                shape:
                                                    MaterialStateProperty.all<
                                                        RoundedRectangleBorder>(
                                                  RoundedRectangleBorder(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            10.0), // Adjust border radius as needed
                                                  ),
                                                ),
                                                backgroundColor:
                                                    MaterialStateProperty.all<Color>(
                                                        const Color.fromARGB(
                                                            255, 2, 130, 6))),
                                            onPressed: () async {
                                              await scheduleCall();
                                              Navigator.pop(context);
                                              setState(() {});
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
                        }
                      },
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 8.0),
                      child: ViewLawyerCard(
                        icon: caseRequest
                            ? (caseApproved
                                ? Icons.manage_accounts
                                : Icons.grid_view)
                            : Icons.how_to_reg,
                        lawyerService: "Court sitting charges: ",
                        amount: lawyerData[0]['sitting_charge'],
                        lawyerServiceInfo: caseRequest
                            ? (caseApproved
                                ? "Case request approved."
                                : "Waiting for lawyer\napproval")
                            : "Hire as\nyour lawyer",
                        buttonText: caseRequest
                            ? (caseApproved ? " Open" : " View")
                            : "Hire",
                        onPressed: caseRequest
                            ? (caseApproved
                                ? () {
                                    Navigator.pushNamed(context, '/view_case',
                                        arguments: {
                                          'request_id':
                                              caseBooked[0]['id'].toString(),
                                          'lawyer_id': lawyerId
                                        });
                                  }
                                : () {
                                    showModalBottomSheet(
                                      context: context,
                                      builder: (BuildContext context) {
                                        return SingleChildScrollView(
                                          // Allows scrolling if the content exceeds the screen height
                                          child: SizedBox(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width *
                                                1, // Set desired width
                                            child: Container(
                                              padding:
                                                  const EdgeInsets.all(20.0),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  const Text(
                                                    'Case Request',
                                                    style: TextStyle(
                                                      fontSize: 24,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(height: 20),
                                                  Text(
                                                    'Subject: ${caseBooked[0]['subject']}',
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(height: 2),
                                                  Text(
                                                    'Description: ${caseBooked[0]['description']}',
                                                    style: const TextStyle(
                                                        fontSize: 18),
                                                  ),
                                                  const SizedBox(height: 20)
                                                ],
                                              ),
                                            ),
                                          ),
                                        );
                                      },
                                    );
                                  })
                            : () {
                                Navigator.pushNamed(context, '/hire_lawyer',
                                    arguments: lawyerId);
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

  scheduleCall() async {
    String selectedDate = _dateController.text;
    String selectedTime = selectedTimeSlot ?? ''; // Handle null case
    String hours = _hourController.text;
    String message = description ?? ''; // Handle null case

    try {
      final response =
          await Supabase.instance.client.from('call_booking').insert({
        'date': selectedDate,
        'time_slot': selectedTime,
        'description': description,
        'client_id': userData['userId'],
        'lawyer_id': lawyerId,
        'hours': hours
      });
      print("Response ===== $response");
      final snackBar = SnackBar(
          content: const Text(
              'Call request has been sent to lawyer. Waiting for the approval.'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              Navigator.pop(context);
            },
          ));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
      setState(() {});
    } catch (e) {
      print("error ===== $e");
      final snackBar = SnackBar(
          content: const Text('Failed to schedule the call.'),
          action: SnackBarAction(
            label: 'Close',
            onPressed: () {
              Navigator.pop(context);
            },
          ));
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(snackBar);
    }
  }
}
