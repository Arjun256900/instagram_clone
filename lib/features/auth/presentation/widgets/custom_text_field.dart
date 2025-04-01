import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController textEditingController;
  final String? errorMessage;
  const CustomTextField({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.textEditingController,
    this.errorMessage,
  });

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool hasError = errorMessage != null;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: textEditingController,
          obscureText: isPassword,
          decoration: InputDecoration(
            hintText: hintText,
            enabledBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: hasError ? Colors.red : Colors.blueGrey,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(
                color: isDarkMode ? Colors.white : Colors.black,
                width: 1,
              ),
              borderRadius: BorderRadius.circular(15),
            ),
            suffixIcon:
                hasError
                    ? const Icon(Icons.error_outline, color: Colors.red)
                    : null,
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
