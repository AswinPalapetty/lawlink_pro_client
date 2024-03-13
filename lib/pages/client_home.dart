import 'package:flutter/material.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';
import 'package:lawlink_client/widgets/custom_info_card.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  @override
  Widget build(BuildContext context) {
    return ClientHomeScaffold(
        child: SingleChildScrollView(
      child: Column(
        children: [
          const Padding(
            padding: EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(
                "How to talk to a lawyer",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomInfoCard(
                onTap: () {},
                infoText: "Select the lawyer you wish to consult.",
                icon: Icons.gavel_rounded,
              )),
          Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: CustomInfoCard(
                  onTap: () {},
                  infoText: "Select the amount of time you wish to talk.",
                  icon: Icons.timer)),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomInfoCard(
              onTap: () {},
              icon: Icons.monetization_on,
              infoText: "Make payment.",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomInfoCard(
              onTap: () {},
              icon: Icons.schedule,
              infoText: "Lawyer will schedule the time slot.",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: ListTile(
              title: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Our top lawyers",
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
                  ),
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context,'/lawyers');
                    },
                    child: const Text(
                      "View All",
                      style: TextStyle(fontSize: 16, color: Colors.blue),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  // Add CircleAvatar widgets here
                  for (int i = 0; i < 10; i++)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 5),
                      child: GestureDetector(
                        onTap: () {},
                        child: const Column(
                          children: [
                            CircleAvatar(
                              backgroundColor: Colors.black,
                              //backgroundImage: AssetImage('assets/images/user.jpg'),
                              radius: 30,
                              child: Icon(Icons.account_circle,
                                  color: Colors.white, size: 60),
                            ),
                            SizedBox(
                                height: 5), // Adjust the vertical spacing here
                            Text(
                              "Padmakumar",
                              overflow: TextOverflow.ellipsis,
                            ),
                          ],
                        ),
                      ),
                    ),
                ],
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsets.all(5.0),
            child: ListTile(
              title: Text(
                "How to hire a lawyer",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomInfoCard(
              onTap: () {},
              icon: Icons.schedule,
              infoText: "Lawyer will schedule the time slot.",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomInfoCard(
              onTap: () {},
              icon: Icons.schedule,
              infoText: "Lawyer will schedule the time slot.",
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: CustomInfoCard(
              onTap: () {},
              icon: Icons.schedule,
              infoText: "Lawyer will schedule the time slot.",
            ),
          ),
          const SizedBox(height: 25)
        ],
      ),
    ));
  }
}
