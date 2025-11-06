// This is only a DTO model

class AuthUserModel {
  final String username;
  final String email;
  final String password;

  const AuthUserModel({
    required this.username,
    required this.email,
    required this.password,
  });

  // Empty constructor for initialization
  const AuthUserModel.empty() : username = '', email = '', password = '';

  // CopyWith for immutable updates
  AuthUserModel copyWith({String? username, String? email, String? password}) {
    return AuthUserModel(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }

  // To JSON (for API requests)
  Map<String, dynamic> toJson() {
    return {'username': username, 'email': email, 'password': password};
  }

  // From JSON
  factory AuthUserModel.fromJson(Map<String, dynamic> json) {
    return AuthUserModel(
      username: json['username'] as String,
      email: json['email'] as String,
      password: json['password'] as String,
    );
  }

  // Validation helpers
  bool get isValid =>
      username.isNotEmpty && email.isNotEmpty && password.isNotEmpty;

  bool get hasValidEmail => email.contains('@') && email.contains('.');

  bool get hasValidPassword => password.length >= 6;

  @override
  String toString() => 'AuthUserModel(username: $username, email: $email)';

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is AuthUserModel &&
        other.username == username &&
        other.email == email &&
        other.password == password;
  }

  @override
  int get hashCode => username.hashCode ^ email.hashCode ^ password.hashCode;
}
