class UserModel {
  String? token;
  String? role;
  String? name; // Naya field add karein
  bool? isLogin;

  UserModel({this.token, this.role, this.name, this.isLogin});

  UserModel.fromJson(Map<String, dynamic> json) {
    token = json['token'];
    role = json['role'];
    name = json['name']; // Backend se name map karein
    isLogin = json['isLogin'];
  }
}