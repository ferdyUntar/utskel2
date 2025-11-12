class User {
  final String userId;
  final String userName;
  final String userPass;

  User({
    required this.userId,
    required this.userName,
    required this.userPass,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      userId: json['user_ID'] ?? '',
      userName: json['user_NAME'] ?? '',
      userPass: json['user_PASS'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_ID': userId,
      'user_NAME': userName,
      'user_PASS': userPass,
    };
  }
}
