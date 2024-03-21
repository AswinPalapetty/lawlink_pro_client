import 'package:flutter/material.dart';

class ViewLawyerBody extends StatelessWidget {
  const ViewLawyerBody({super.key, required this.aboutLawyer, required this.experience, required this.location, this.onTap, this.child});

  final String aboutLawyer;
  final String experience;
  final String location;
  final void Function()? onTap;
  final Widget? child;

  @override
  Widget build(BuildContext context) {
    return Stack(children: [
                ListTile(
                  title: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(aboutLawyer),
                      Text("Experience : $experience"),
                      Padding(
                        padding: const EdgeInsets.only(top: 7, bottom: 7),
                        child: Row(
                          children: [
                            const Icon(
                              Icons.location_on,
                              size: 30,
                            ),
                            Text(
                              " $location",
                              style: const TextStyle(fontSize: 17),
                            )
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Positioned(
                  top: 0,
                  right: 4,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: GestureDetector(
                      onTap: onTap,
                      child: child!,
                    ),
                  ),
                )
              ]);
  }
}