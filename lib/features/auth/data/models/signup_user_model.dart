class SignupUserModel {
  final String? mobile;
  final String? name;
  final String? email;
  final String? dob;
  final String? username;
  final String? password;
  final bool? isMobile;

  SignupUserModel({
    this.mobile,
    this.name,
    this.email,
    this.dob,
    this.username,
    this.password,
    this.isMobile,
  });

  SignupUserModel copyWith({
    String? mobile,
    String? name,
    String? email,
    String? dob,
    String? username,
    String? password,
    bool? isMobile,
  }) {
    return SignupUserModel(
      mobile: mobile ?? this.mobile,
      name: name ?? this.name,
      email: email ?? this.email,
      dob: dob ?? this.dob,
      username: username ?? this.username,
      password: password ?? this.password,
      isMobile: isMobile ?? this.isMobile,
    );
  }
}
