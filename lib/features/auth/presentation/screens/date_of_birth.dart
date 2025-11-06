import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:instagram/features/auth/presentation/widgets/already_have_account.dart';
import 'package:instagram/features/auth/presentation/screens/set_name_screen.dart';
import 'package:instagram/features/auth/presentation/widgets/auth_button.dart';
import 'package:instagram/features/user-profile/providers/profile_provider.dart';
import 'package:intl/intl.dart'; // for date formatting
import 'package:instagram/features/auth/presentation/widgets/hero_text.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class DateOfBirth extends ConsumerStatefulWidget {
  const DateOfBirth({super.key});

  @override
  ConsumerState<DateOfBirth> createState() => _DateOfBirthState();
}

class _DateOfBirthState extends ConsumerState<DateOfBirth> {
  DateTime? selectedDate;
  String? errorMessage;
  bool hasTriedToSubmit = false;

  // Function to calculate age from birth date
  int _calculateAge(DateTime birthDate) {
    final today = DateTime.now();
    int age = today.year - birthDate.year;
    if (today.month < birthDate.month ||
        (today.month == birthDate.month && today.day < birthDate.day)) {
      age--;
    }
    return age;
  }

  void validateInput() {
    hasTriedToSubmit = true;
    if (selectedDate == null) {
      setState(() {
        errorMessage =
            "It looks like you've entered the wrong info. Please make sure that you use your real date of birth";
      });
      return;
    }
    final age = _calculateAge(selectedDate!);
    if (age < 4) {
      setState(() {
        errorMessage =
            "Sorry, but you need to be at least 4 years old to use this app.";
      });
      return;
    }
    setState(() {
      errorMessage = null;
    });
    String formattedDate =
        selectedDate == null
            ? ''
            : DateFormat('d MMMM yyyy').format(selectedDate!);
    ref.read(profileProvider.notifier).setDob(formattedDate);
    debugPrint("DOB: ${ref.watch(profileProvider).dob}");
    Navigator.push(
      context,
      CupertinoPageRoute(builder: (context) => SetNameScreen()),
    );
  }

  void _showWhyDateOfBirthModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true, // Allows custom height
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (BuildContext context) {
        return Container(
          padding: EdgeInsets.all(20),
          height:
              MediaQuery.of(context).size.height * 0.75, // 75% screen height
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
              SizedBox(height: 15),
              Text(
                "Birthdays",
                style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 20),
              Text(
                "Providing your date of birth improves the features and ads you see and helps to keep the Instagram community safe. You can find your date of birth in your personal information account",
                style: TextStyle(fontSize: 16),
              ),
            ],
          ),
        );
      },
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1950),
      lastDate: DateTime.now(),
    );
    if (picked != null && picked != selectedDate) {
      setState(() {
        selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    // Format the date into the desired format
    String formattedDate =
        selectedDate == null
            ? ''
            : DateFormat('d MMMM yyyy').format(selectedDate!);

    // Calculate the age of the user
    String ageText =
        selectedDate == null ? '18' : '${_calculateAge(selectedDate!)}';

    // Fix: Correct error flag condition.
    final bool hasError = errorMessage != null && hasTriedToSubmit;

    return GestureDetector(
      onTap: () {
        FocusManager.instance.primaryFocus?.unfocus();
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text("")),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              HeroText(
                isDarkMode: isDarkMode,
                subText:
                    "Use your own date of birth, even if this account is for a business, a pet or something else. No one will see this unless you choose to share it.",
                text: "What's your date of birth?",
              ),
              TextButton(
                onPressed: () {
                  _showWhyDateOfBirthModal(context);
                },
                child: Text(
                  "Why do I need to provide my date of birth?",
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.blueAccent,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              GestureDetector(
                onTap: () => _selectDate(context),
                child: AbsorbPointer(
                  // Prevents keyboard from showing
                  child: TextField(
                    controller: TextEditingController(
                      text: formattedDate, // Show the formatted date here
                    ),
                    decoration: InputDecoration(
                      hintText: "Your Birthday",
                      suffixText: "$ageText years old",
                      suffixIcon:
                          hasError
                              ? Icon(Icons.error_outline, color: Colors.red)
                              : null,
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
                    ),
                  ),
                ),
              ),
              // New widget to display error messages
              if (hasError)
                Padding(
                  padding: const EdgeInsets.only(top: 8.0),
                  child: Text(
                    errorMessage!,
                    style: TextStyle(color: Colors.red, fontSize: 14),
                  ),
                ),
              const SizedBox(height: 20),
              AuthButton(
                text: "Next",
                // Disable the button if there's an error or if no date is selected.
                isEnabled: errorMessage == null && selectedDate != null,
                hasTriedToSubmit: hasTriedToSubmit,
                onPressed: validateInput,
              ),
              const Spacer(),
              AlreadyHaveAccount(num: 3),
            ],
          ),
        ),
      ),
    );
  }
}
