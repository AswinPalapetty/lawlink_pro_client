import 'package:flutter/material.dart';
import 'package:expandable_text/expandable_text.dart';

class LawyersCard extends StatelessWidget {
  const LawyersCard(
      {super.key,
      this.onTap,
      this.lawyerName,
      this.description,
      this.imageUrl,
      this.rating,
      this.education,
      this.experience,
      this.courts,
      this.location,
      this.lawyerId,
      this.callCharge,
      this.courtCharge});

  final void Function()? onTap;
  final String? lawyerName;
  final String? description;
  final String? imageUrl;
  final String? rating,
      lawyerId,
      education,
      experience,
      courts,
      location,
      callCharge,
      courtCharge;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(10, 20, 10,
          20), // Adjust top padding to make space for the search bar
      child: Container(
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
        child: GestureDetector(
          onTap: () {
            Navigator.pushNamed(context, "/view_lawyer",
                arguments: lawyerId);
          },
          child: Card(
            color: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
            child: Column(
              children: [
                Stack(
                  children: [
                    ListTile(
                      title: Row(
                        children: [
                          Text(
                            lawyerName!,
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.w600),
                          ),
                          const Text(" "),
                          Icon(
                            Icons.verified,
                            color: Colors.blue.shade600,
                          )
                        ],
                      ),
                      subtitle: ExpandableText(
                        description!, //"Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                        expandText: 'show more',
                        collapseText: 'show less',
                        maxLines: 3,
                        linkColor: Colors.blue,
                        style: const TextStyle(
                            fontSize: 15,
                            color: Color.fromARGB(255, 57, 57, 57)),
                      ),
                      leading: CircleAvatar(
                        maxRadius: 25,
                        backgroundColor:
                            Colors.black, //Color.fromARGB(255, 10, 63, 105),
                        child: imageUrl != null
                            ? Image.asset(imageUrl!)
                            : const Icon(Icons.account_circle,
                                color: Colors.white, size: 50),
                        //Icon(Icons.person,color: Colors.white, size: 35),
                      ),
                    ),
                    Positioned(
                      top: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          padding: const EdgeInsets.all(8),
                          decoration: const BoxDecoration(
                            color: Color.fromARGB(255, 2, 130, 6),
                            borderRadius: BorderRadius.all(
                              Radius.circular(10),
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Icon(Icons.star, color: Colors.white),
                              const SizedBox(width: 4),
                              Text(
                                rating!,
                                style: const TextStyle(
                                    fontSize: 16,
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                  ],
                ),
                Stack(children: [
                  ListTile(
                    title: Text("${education!}\n"
                        "Experience : ${experience!}\n"
                        "Courts : ${courts!}\n"),
                  ),
                ]),
                Padding(
                  padding: const EdgeInsets.only(top: 0, bottom: 20),
                  child: Container(
                    height: 1,
                    color: Colors.grey, // Set the color of the line
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.location_on,
                        size: 30,
                      ),
                      Text(
                        "$location",
                        style: const TextStyle(fontSize: 17),
                      )
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15),
                  child: Row(
                    children: [
                      const Text("Call charges : ",
                          style: TextStyle(fontSize: 18)),
                      Text(
                        "Rs.$callCharge",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Text("/hr", style: TextStyle(fontSize: 18))
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15, bottom: 25),
                  child: Row(
                    children: [
                      const Text("Court charges : ",
                          style: TextStyle(fontSize: 18)),
                      Text(
                        "Rs.$courtCharge",
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                      const Text("(for one sitting)",
                          style: TextStyle(
                              fontSize: 14, fontStyle: FontStyle.italic))
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(15),
                //   child: SizedBox(
                //     width: double.infinity,
                //     child: Row(
                //       children: [
                //         Expanded(
                //           flex: 1,
                //           child: ElevatedButton(
                //               style: ButtonStyle(
                //                   iconColor: MaterialStateProperty.all<Color>(
                //                       Colors.white),
                //                   shape: MaterialStatePropertyAll(
                //                       BeveledRectangleBorder(
                //                           borderRadius:
                //                               BorderRadius.circular(8))),
                //                   backgroundColor: MaterialStateProperty.all<
                //                           Color>(
                //                       const Color.fromARGB(255, 2, 130, 6))),
                //               onPressed: () {
                //                 // Add your button onPressed logic here
                //               },
                //               child: const Row(
                //                 children: [
                //                   Text(" "),
                //                   Icon(Icons.call),
                //                   Text(' Audio call',
                //                       style: TextStyle(
                //                           color: Colors.white, fontSize: 15))
                //                 ],
                //               )),
                //         ),
                //         const SizedBox(
                //             width:
                //                 8), // Add some space between the button and the card's edge
                //         Expanded(
                //           flex: 1,
                //           child: ElevatedButton(
                //             style: ButtonStyle(
                //                 iconColor: MaterialStateProperty.all<Color>(
                //                     Colors.white),
                //                 shape: MaterialStatePropertyAll(
                //                     BeveledRectangleBorder(
                //                         borderRadius:
                //                             BorderRadius.circular(8))),
                //                 backgroundColor: MaterialStateProperty.all<
                //                         Color>(
                //                     const Color.fromARGB(255, 87, 13, 246))),
                //             onPressed: () {
                //               // Add your button onPressed logic here
                //             },
                //             child: const Row(
                //               children: [
                //                 Icon(Icons.home),
                //                 Text(' Court sitting',
                //                     style: TextStyle(
                //                         color: Colors.white, fontSize: 15))
                //               ],
                //             ),
                //           ),
                //         ),
                //       ],
                //     ),
                //   ),
                // )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
