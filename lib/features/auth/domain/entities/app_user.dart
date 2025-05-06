class AppUser {
  final String uid;
  final String email;
  final String name;
  final String username;

  AppUser({
    required this.uid,
    required this.email,
    required this.name,
    required this.username,
  });

  Map<String, dynamic> toJson() {
    return {'uid': uid, 'email': email, 'name': name, 'username': username};
  }

  factory AppUser.fromMap(Map<String, dynamic> json) {
    return AppUser(
      uid: json['uid'],
      email: json['email'],
      name: json['name'],
      username: json['username'],
    );
  }
}
