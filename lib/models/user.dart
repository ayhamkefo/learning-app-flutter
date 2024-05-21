class User {
  String? id;
  String? name;
  String? email;
  String? role;
  User({this.id, this.name, this.role, this.email});
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        id: json['id'].toString(),
        name: json['name'].toString(),
        email: json['email'].toString(),
        role: json['role'].toString());
  }
}
