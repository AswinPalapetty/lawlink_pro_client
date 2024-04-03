import 'package:flutter/material.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';
import 'package:lawlink_client/widgets/custom_info_card.dart';
import 'package:lawlink_client/widgets/progress_indicator.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  late PostgrestList userData;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchLawyers();
  }

  fetchLawyers() async {
    userData = await Supabase.instance.client.from('lawyers').select();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ClientHomeScaffold(
        child: SingleChildScrollView(
      child: isLoading
          ? const CustomProgressIndicator()
          : Column(
              children: [
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: ListTile(
                    title: Text(
                      "How to talk to a lawyer",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
                          style: TextStyle(
                              fontSize: 20, fontWeight: FontWeight.w600),
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.pushNamed(context, '/lawyers');
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
                      children: userData.map((user) {
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 5),
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                "/view_lawyer",
                                arguments: user['user_id']
                              );
                            },
                            child: Column(
                              children: [
                                CircleAvatar(
                                  backgroundColor: Colors.black,
                                  radius: 30,
                                  backgroundImage: user['image'] != null &&
                                          user['image'] != ''
                                      ? AssetImage(user['image'])
                                      : null,
                                  child: user['image'] != null &&
                                          user['image'] != ''
                                      ? null
                                      : const Icon(Icons.account_circle,
                                          color: Colors.white, size: 60),
                                ),
                                const SizedBox(
                                    height:
                                        5), // Adjust the vertical spacing here
                                Text(user['name'],
                                    overflow: TextOverflow.ellipsis),
                              ],
                            ),
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                const Padding(
                  padding: EdgeInsets.all(5.0),
                  child: ListTile(
                    title: Text(
                      "How to hire a lawyer",
                      style:
                          TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
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
