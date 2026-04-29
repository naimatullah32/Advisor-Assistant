import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/login/user_model.dart';

class UserPreference {

  Future<bool> saveUser(UserModel user) async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    await sp.setString('token', user.token ?? '');
    await sp.setString('role', user.role ?? '');
    await sp.setBool('isLogin', user.isLogin ?? false);

    return true;
  }

  Future<UserModel> getUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();

    String? token = sp.getString('token');
    String? role = sp.getString('role');
    bool? isLogin = sp.getBool('isLogin');

    return UserModel(
      token: token,
      role: role,
      isLogin: isLogin ?? false,
    );
  }

  Future<bool> removeUser() async {
    final SharedPreferences sp = await SharedPreferences.getInstance();
    await sp.clear();
    return true;
  }
}
