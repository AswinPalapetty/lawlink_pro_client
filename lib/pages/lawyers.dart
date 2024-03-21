import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';

class Lawyers extends StatefulWidget {
  const Lawyers({super.key});

  @override
  State<Lawyers> createState() => _LawyersState();
}

class _LawyersState extends State<Lawyers> {
  Color? iconColor = Colors.black;
  IconData? icon = Icons.thumb_up_alt_outlined;
  @override
  Widget build(BuildContext context) {
    return ClientHomeScaffold(
      child: Stack(
        children: [
          Positioned(
            // Positioned widget for fixed position
            top: 10, // Adjust top position as needed
            left: 10, // Adjust left position as needed
            right: 10, // Adjust right position as needed
            child: Padding(
              padding: const EdgeInsets.all(10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(30),
                ),
                width: MediaQuery.of(context).size.width,
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: TextField(
                  onChanged: (value) {},
                  decoration: const InputDecoration(
                    hintText: 'Search...',
                    hintStyle: TextStyle(color: Colors.grey),
                    border: InputBorder.none,
                    icon: Icon(Icons.search),
                  ),
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.fromLTRB(10, 90, 10,20), // Adjust top padding to make space for the search bar
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
                    Navigator.pushNamed(context, "/view_lawyer");
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
                                  const Text(
                                    "Aswin P",
                                    style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.w600),
                                  ),
                                  const Text(" "),
                                  Icon(Icons.verified, color: Colors.blue.shade600,)
                                ],
                              ),
                              // subtitle: Text(
                              //   "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                              //   style: TextStyle(fontSize: 15,color: Colors.black),
                  
                              // ),
                              subtitle: const ExpandableText(
                                "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam.",
                                expandText: 'show more',
                                collapseText: 'show less',
                                maxLines: 3,
                                linkColor: Colors.blue,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color.fromARGB(255, 57, 57, 57)),
                              ),
                              leading: const CircleAvatar(
                                maxRadius: 25,
                                backgroundColor: Colors.black, //Color.fromARGB(255, 10, 63, 105),
                                child: Icon(Icons.account_circle,
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
                                  child: const Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.star, color: Colors.white),
                                      SizedBox(width: 4),
                                      Text(
                                        '4.5',
                                        style: TextStyle(
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
                          const ListTile(
                            title: Text("Lorem ipsum dolor sit amet,\n"
                                " consectetur adipiscing elit,\n"
                                "sed do eiusmod tempor\n"
                                " incididunt ut labore et\n"
                                " dolore magna aliqua. Ut enim ad minim veniam.\n"),
                          ),
                          Positioned(
                            top: 0,
                            right: 4,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: GestureDetector(
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
                            ),
                          )
                        ]),
                        Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 20),
                          child: Container(
                            height: 1,
                            color: Colors.grey, // Set the color of the line
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(
                                Icons.location_on,
                                size: 30,
                              ),
                              Text(
                                " Bangalore, Karnataka",
                                style: TextStyle(fontSize: 17),
                              )
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Text("Call charges : ",
                                  style: TextStyle(fontSize: 18)),
                              Text(
                                "Rs.300",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text("/hr", style: TextStyle(fontSize: 18))
                            ],
                          ),
                        ),
                        const Padding(
                          padding: EdgeInsets.only(left: 15),
                          child: Row(
                            children: [
                              Text("Court charges : ",
                                  style: TextStyle(fontSize: 18)),
                              Text(
                                "Rs.10,000",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 20),
                              ),
                              Text("(for one sitting)",
                                  style: TextStyle(
                                      fontSize: 14, fontStyle: FontStyle.italic))
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(15),
                          child: SizedBox(
                            width: double.infinity,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                      style: ButtonStyle(
                                          iconColor:
                                              MaterialStateProperty.all<Color>(
                                                  Colors.white),
                                          shape: MaterialStatePropertyAll(
                                              BeveledRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(8))),
                                          backgroundColor:
                                              MaterialStateProperty.all<Color>(
                                                  const Color.fromARGB(
                                                      255, 2, 130, 6))),
                                      onPressed: () {
                                        // Add your button onPressed logic here
                                      },
                                      child: const Row(
                                        children: [
                                          Text(" "),
                                          Icon(Icons.call),
                                          Text(' Audio call',
                                              style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 15))
                                        ],
                                      )),
                                ),
                                const SizedBox(
                                    width:
                                        8), // Add some space between the button and the card's edge
                                Expanded(
                                  flex: 1,
                                  child: ElevatedButton(
                                    style: ButtonStyle(
                                        iconColor:
                                            MaterialStateProperty.all<Color>(
                                                Colors.white),
                                        shape: MaterialStatePropertyAll(
                                            BeveledRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(8))),
                                        backgroundColor:
                                            MaterialStateProperty.all<Color>(
                                                const Color.fromARGB(255, 87, 13, 246))),
                                    onPressed: () {
                                      // Add your button onPressed logic here
                                    },
                                    child: const Row(
                                      children: [
                                        Icon(Icons.home),
                                        Text(' Court sitting',
                                            style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 15))
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
