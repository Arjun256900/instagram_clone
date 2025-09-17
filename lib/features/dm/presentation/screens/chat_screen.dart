import 'package:flutter/material.dart';

class ChatScreen extends StatelessWidget {
  final String name;
  const ChatScreen({super.key, required this.name});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(name, style: const TextStyle(fontWeight: FontWeight.w600)),
      ),
      body: const Center(
        child: Text("Chat screen", textAlign: TextAlign.center),
      ),
    );
  }
}
