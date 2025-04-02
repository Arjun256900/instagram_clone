import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  final String hintText;
  final bool isPassword;
  final TextEditingController textEditingController;
  final String? errorMessage;
  final bool isMobile;

  const CustomTextField({
    super.key,
    required this.hintText,
    required this.isPassword,
    required this.textEditingController,
    this.errorMessage,
    required this.isMobile,
  });

  @override
  _CustomTextFieldState createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final bool hasError = widget.errorMessage != null;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextField(
          controller: widget.textEditingController,
          obscureText: widget.isPassword ? _isObscure : false,
          keyboardType:
              widget.isMobile ? TextInputType.number : TextInputType.name,
          decoration: InputDecoration(
            hintText: widget.hintText,
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
                    : widget.isPassword
                    ? IconButton(
                      icon: Icon(
                        _isObscure ? Icons.visibility_off : Icons.visibility,
                        color: isDarkMode ? Colors.white : Colors.black,
                      ),
                      onPressed: () {
                        setState(() {
                          _isObscure = !_isObscure;
                        });
                      },
                    )
                    : null,
          ),
        ),
        if (hasError)
          Padding(
            padding: const EdgeInsets.only(top: 5, left: 5),
            child: Text(
              widget.errorMessage!,
              style: const TextStyle(color: Colors.red, fontSize: 12),
            ),
          ),
      ],
    );
  }
}
