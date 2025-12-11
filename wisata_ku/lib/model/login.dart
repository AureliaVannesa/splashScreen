class Login {
  String? token;
  int? userID;
  String? email;

  Login({this.token, this.userID, this.email});

  factory Login.fromJson(Map<String, dynamic> json) {
    return Login(
      token: json['token'],
      userID: int.tryParse(json['user']?['id'].toString() ?? ''),
      email: json['user']?['email'],
    );
  }
}
