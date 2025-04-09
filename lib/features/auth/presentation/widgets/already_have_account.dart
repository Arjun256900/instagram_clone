import 'package:flutter/material.dart';

class AlreadyHaveAccount extends StatelessWidget {
  final int num;
  const AlreadyHaveAccount({super.key, required this.num});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          TextButton(
            style: TextButton.styleFrom(foregroundColor: Colors.blueAccent),
            onPressed: () {
              showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialog(
                    title: Text("Already have an account?"),
                    actions: <Widget>[
                      TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(
                          "CONTINUE CREATING ACCOUNT",
                          style: TextStyle(color: Colors.red[400]),
                        ),
                      ),
                      TextButton(
                        onPressed: () {
                          for (int i = 0; i < num; i++) {
                            Navigator.pop(context);
                          }
                        },
                        child: Text(
                          "LOG IN",
                          style: TextStyle(color: Colors.blueAccent),
                        ),
                      ),
                    ],
                  );
                },
              );
            },
            child: const Text("I already have an account"),
          ),
          const SizedBox(height: 15),
        ],
      ),
    );
  }
}
