import 'package:flutter/material.dart';

class FavouriteLawyerCard extends StatelessWidget {
  final String name;
  final String practiceAreas;
  final String imageUrl;
  final VoidCallback? onTap;

  const FavouriteLawyerCard({
    super.key,
    required this.name,
    required this.practiceAreas,
    required this.imageUrl,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 8.0, left: 8, right: 8),
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: InkWell(
          onTap: onTap,
          child: Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.5),
                  spreadRadius: 2,
                  blurRadius: 5,
                  offset: const Offset(0, 3),
                ),
              ],
            ),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListTile(
                leading: CircleAvatar(
                  backgroundImage: NetworkImage(imageUrl),
                ),
                title: Text(
                  name,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                subtitle: Text("Practice areas: $practiceAreas"),
                trailing: const Icon(Icons.arrow_forward_ios), // Add your desired icon here
              ),
            ),
          ),
        ),
      ),
    );
  }
}
