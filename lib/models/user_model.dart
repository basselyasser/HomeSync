class AppUser {
  final String username;
  final String email;
  final String uid;
  final DateTime createdAt;

  AppUser({
    required this.username,
    required this.email,
    required this.uid,
    required this.createdAt,
  });

  factory AppUser.fromJson(Map<String, dynamic> json) {
    return AppUser(
      username: json['username'],
      email: json['email'],
      uid: json['uid'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }
}
