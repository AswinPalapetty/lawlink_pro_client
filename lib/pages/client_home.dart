import 'package:flutter/material.dart';
import 'package:lawlink_client/widgets/client_home_scaffold.dart';

class ClientHome extends StatefulWidget {
  const ClientHome({super.key});

  @override
  State<ClientHome> createState() => _ClientHomeState();
}

class _ClientHomeState extends State<ClientHome> {
  @override
  Widget build(BuildContext context) {
    return const ClientHomeScaffold(
      child: Column(),
    );
  }
}