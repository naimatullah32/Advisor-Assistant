import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../models/login/user_model.dart';
import '../../../repository/login_repository/login_repository.dart';
import '../../../res/routes/routes_name.dart';
import '../../../utils/utils.dart';
import '../user_preference/user_prefrence_view_model.dart';

class LoginViewModel extends GetxController {

  final _api = LoginRepository();
  final UserPreference userPreference = UserPreference();

  /// Text Controllers (NO .obs needed)
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  /// Focus Nodes
  final FocusNode emailFocusNode = FocusNode();
  final FocusNode passwordFocusNode = FocusNode();

  /// States
  RxBool loading = false.obs;
  RxBool obscurePassword = true.obs;

  void togglePassword() {
    obscurePassword.value = !obscurePassword.value;
  }

  /// LOGIN API
  void loginApi() async {

    if (emailController.text.isEmpty) {
      Utils.toastMessage('Please enter email');
      return;
    }

    if (passwordController.text.isEmpty) {
      Utils.toastMessage('Please enter password');
      return;
    }

    loading.value = true;

    Map<String, dynamic> data = {
      'email': emailController.text.trim(),
      'password': passwordController.text.trim(),
    };

    try {

      final value = await _api.loginApi(data);

      loading.value = false;

      /// IMPORTANT: backend se value ka structure check karo
      /// Agar backend aisa bhej raha hai:
      /// { message: "...", user: { role: "advisor" } }

      final userData = value['user'];   // 👈 yeh line important

      UserModel userModel = UserModel(
        token: "dummy_token",
        role: userData['role'],
        isLogin: true,
      );

      await userPreference.saveUser(userModel);

      switch (userData['role']) {

        case 'admin':
          Get.offAllNamed(RouteName.adminHomeView);
          break;

        case 'teacher':
          Get.offAllNamed(RouteName.teacherHomeView);
          break;

        case 'student':
          Get.offAllNamed(RouteName.studentHomeView);
          break;

        case 'parent':
          Get.offAllNamed(RouteName.parentHomeView);
          break;

        case 'advisor':
          Get.offAllNamed(RouteName.advisorHomeView);
          break;

        default:
          Get.offAllNamed(RouteName.loginView);
      }

    } catch (error) {
      loading.value = false;
      Utils.toastMessage(error.toString());
    }
  }


  @override
  void onClose() {
    emailController.dispose();
    passwordController.dispose();
    emailFocusNode.dispose();
    passwordFocusNode.dispose();
    super.onClose();
  }
}
