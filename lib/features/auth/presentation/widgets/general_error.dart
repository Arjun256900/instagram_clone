import 'package:flutter/material.dart';

class GeneralError extends StatelessWidget {
  final String error;
  const GeneralError({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Text(
      error,
      style: TextStyle(
        color: Colors.red,
        fontWeight: FontWeight.w600,
        fontSize: 16,
      ),
    );
  }
}
