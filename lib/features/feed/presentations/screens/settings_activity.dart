import 'package:flutter/material.dart';

class SettingsActivity extends StatelessWidget {
  const SettingsActivity({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus!.unfocus();
      },
      child: Scaffold(
        appBar: AppBar(title: Text("Settings and activity")),
        body: Padding(
          padding: const EdgeInsets.all(14.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              TextField(
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.blueGrey.withOpacity(0.3),
                  prefixIcon: Icon(Icons.search, size: 20),
                  hintText: "Search",
                  contentPadding: EdgeInsets.symmetric(vertical: 6),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
                style: TextStyle(fontSize: 14),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
