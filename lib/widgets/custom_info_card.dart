import 'package:flutter/material.dart';

class CustomInfoCard extends StatelessWidget {
  const CustomInfoCard({super.key, this.infoText, required this.onTap, this.icon});

  final String? infoText;
  final void Function()? onTap;
  final IconData? icon; 

  @override
  Widget build(BuildContext context) {
    return Card(
            elevation: 10,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10), // border radius
              side: BorderSide(color: Colors.grey[300]!), // border color
            ),
            child: InkWell(
              onTap: onTap,
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white, // background color
                  borderRadius: BorderRadius.circular(10), // border radius
                ),
                padding: const EdgeInsets.all(16), // padding around the content
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ListTile(
                      title: Text(
                        infoText!,
                        style:
                            const TextStyle(fontWeight: FontWeight.bold), // bold text
                      ),
                      leading: CircleAvatar(
                        backgroundColor: const Color.fromARGB(255, 10, 63, 105),
                        child: Icon(icon, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );
  }
}