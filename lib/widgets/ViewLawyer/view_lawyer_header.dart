import 'package:expandable_text/expandable_text.dart';
import 'package:flutter/material.dart';

class ViewLawyerHeader extends StatelessWidget {
  const ViewLawyerHeader({
    super.key,
    required this.lawyerName,
    required this.aboutLawyer, required this.child,
  });

  final String lawyerName;
  final String aboutLawyer;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Row(
        children: [
          Text(
            lawyerName,
            style: const TextStyle(fontSize: 30, fontWeight: FontWeight.w600),
          ),
          const Text(" "),
          Icon(
            Icons.verified,
            size: 28,
            color: Colors.blue.shade600,
          )
        ],
      ),
      subtitle: ExpandableText(
        aboutLawyer,
        expandText: 'show more',
        collapseText: 'show less',
        maxLines: 4,
        linkColor: Colors.blue,
        style: const TextStyle(
            fontSize: 16, color: Color.fromARGB(255, 57, 57, 57)),
      ),
      leading: CircleAvatar(
        maxRadius: 40,
        backgroundColor: Colors.black,
        child: child,
      ),
    );
  }
}
