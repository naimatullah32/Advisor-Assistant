import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../view_models/controller/login/login_view_model.dart';

class InputPasswordWidget extends StatelessWidget {
  InputPasswordWidget({Key? key}) : super(key: key);

  final loginVM = Get.find<LoginViewModel>();

  @override
  Widget build(BuildContext context) {
    return Obx(() => TextFormField(
      controller: loginVM.passwordController,
      focusNode: loginVM.passwordFocusNode,
      obscureText: loginVM.obscurePassword.value,
      decoration: InputDecoration(
        hintText: "Password",
        prefixIcon: const Icon(Icons.lock_outline),
        suffixIcon: IconButton(
          icon: Icon(
            loginVM.obscurePassword.value
                ? Icons.visibility_off
                : Icons.visibility,
          ),
          onPressed: loginVM.togglePassword,
        ),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    ));
  }
}
