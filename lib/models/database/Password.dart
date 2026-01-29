
class Password {
  final int? id_pwd;
  final String password;
  final String service;
  final String username;
  final String website;
  final bool is_favorite;
  final int id_category;
  final int last_update;

  Password({
    this.id_pwd,
    required this.password,
    required this.username,
    required this.service,
    String? website,
    bool? is_favorite,
    required this.id_category,
    required this.last_update,
  }) : website = website ?? '',
       is_favorite = is_favorite ?? false;

  Map<String, dynamic> toMap() {
    return {
      'id_pwd': id_pwd,
      'password': password,
      'username': username,
      'service': service,
      'website': website,
      'is_favorite': is_favorite ? 1 : 0,
      'id_category': id_category,
      'last_update': last_update,
    };
  }

  Password.fromMap(Map<String, dynamic> data)
      : id_pwd = data["id_pwd"],
        password = data["password"],
        username = data["username"],
        service = data["service"],
        website = data["website"] ?? '',
        is_favorite = data["is_favorite"] == 1,
        id_category = data["id_category"],
        last_update = data["last_update"];


  @override
  String toString() {
    return 'Password{id_pwd_password: $id_pwd, password: $password, username: $username, service: $service, website: $website, is_favorite: $is_favorite, id_category: $id_category, last_update: $last_update}';
  }
}