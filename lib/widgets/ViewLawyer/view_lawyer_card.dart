import 'package:flutter/material.dart';

class ViewLawyerCard extends StatelessWidget {
  const ViewLawyerCard({
    super.key,
    required this.lawyerService,
    required this.amount,
    required this.lawyerServiceInfo,
    required this.buttonText,
    this.onPressed,
  });

  final String lawyerService;
  final String amount;
  final String lawyerServiceInfo;
  final String buttonText;
  final void Function()? onPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.3), // Shadow color
              spreadRadius: 3, // Spread radius
              blurRadius: 10, // Blur radius
              //offset: const Offset(5, 5), // Offset in x and y direction
            ),
          ],
        ),
        child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                ListTile(
                  title: Row(
                    children: [
                      Text(lawyerService, style: const TextStyle(fontSize: 18)),
                      const Spacer(),
                      const Text("Rs.", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                      Text(
                        amount,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Text("/hr", style: TextStyle(fontSize: 18))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20),
                  child: Container(
                    height: 1,
                    color: Colors.grey, // Set the color of the line
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(20.0),
                  child: Row(
                    children: [
                      Text(lawyerServiceInfo,
                          style: const TextStyle(fontSize: 18)),
                      const Spacer(),
                      ElevatedButton(
                          style: ButtonStyle(
                            backgroundColor:
                                const MaterialStatePropertyAll(Colors.white),
                            side: MaterialStateProperty.all<BorderSide>(
                              const BorderSide(color: Colors.black),
                            ),
                          ),
                          onPressed: onPressed,
                          child: Row(
                            children: [
                              const Icon(Icons.calendar_month),
                              Text(buttonText,
                                  style: const TextStyle(
                                      color: Colors.black, fontSize: 15))
                            ],
                          ))
                    ],
                  ),
                ),
              ],
            )));
  }
}
