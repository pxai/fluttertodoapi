class User {
  int id;
  String email;
  String password;
  String token;

  User(
      {required this.id,
      required this.email,
      required this.password,
      this.token = ''});

  setToken(String token) {
    this.token = token;
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      password: json['password'],
    );
  }

  User copyWith({int? id, String? email, String? password}) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      password: password ?? this.password,
    );
  }
}
