
class Password {
  final int id_pwd;
  final String password;
  final String username;
  final String website;
  final int id_category;

  Password({
    required this.id_pwd,
    required this.password,
    required this.username,
    String? website,
    required this.id_category,
  }) : this.website = website ?? '';

  Map<String, dynamic> toMap() {
    return {
      'id_pwd': id_pwd,
      'password': password,
      'username': username,
      'website': website,
      'id_category': id_category,
    };
  }

  Password.fromMap(Map<String, dynamic> data)
      : id_pwd = data["id_pwd"],
        password = data["password"],
        username = data["username"],
        website = data["website"] ?? '',
        id_category = data["id_category"];


  @override
  String toString() {
    return 'Password{id_pwd_password: $id_pwd, password: $password, username: $username, website: $website, id_category: $id_category}';
  }
}