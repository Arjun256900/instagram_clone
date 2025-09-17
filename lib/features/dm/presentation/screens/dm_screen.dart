// ignore_for_file: depend_on_referenced_packages

import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:instagram/features/dm/presentation/widgets/dm_list.dart';
import 'package:instagram/features/dm/presentation/widgets/dm_notes.dart';

class DmScreen extends StatefulWidget {
  const DmScreen({super.key});

  @override
  State<DmScreen> createState() => _DmScreenState();
}

class _DmScreenState extends State<DmScreen> {
  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final backgroundColor = isDark ? Colors.black : Colors.white;
    return Scaffold(
      backgroundColor: backgroundColor, // Set scaffold background color
      appBar: AppBar(
        backgroundColor: backgroundColor,
        elevation:
            0, // Remove shadow (that weird material design thingy google loves, for some reason)
        scrolledUnderElevation: 0, // Prevent elevation change on scroll
        title: Text(
          "arjuncm104",
          style: TextStyle(
            fontSize: 23,
            color: isDark ? Colors.white : Colors.black,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(FontAwesomeIcons.pencil, size: 20),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: GestureDetector(
          onTap: () => FocusManager.instance.primaryFocus!.unfocus(),
          child: Padding(
            padding: EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            child: Column(
              children: [
                TextFormField(
                  style: const TextStyle(color: Colors.white, fontSize: 16),
                  decoration: InputDecoration(
                    hintText: "Ask Meta AI or Search",
                    hintStyle: const TextStyle(
                      color: Colors.white70,
                      fontSize: 16,
                    ),
                    prefixIcon: const Icon(Icons.search, color: Colors.white70),
                    filled: true,
                    fillColor: const Color(0xFF2A2A2A),
                    contentPadding: const EdgeInsets.symmetric(vertical: 12),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30),
                      borderSide: BorderSide.none,
                    ),
                  ),
                ),
                const SizedBox(height: 58),
                DmNotes(),
                DmList(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
