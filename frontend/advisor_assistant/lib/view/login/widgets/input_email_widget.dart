import 'package:advisor_assistant/view_models/controller/login/login_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class InputEmailWidget extends StatelessWidget {
   InputEmailWidget({Key? key}) : super(key: key);

  final loginvm = Get.put(LoginViewModel()) ;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: loginvm.emailController,
      focusNode: loginvm.emailFocusNode,
      decoration: InputDecoration(
        hintText: "Enter email or Username",
        prefixIcon: const Icon(Icons.person_outline),
        filled: true,
        fillColor: Colors.white,
        contentPadding: const EdgeInsets.symmetric(vertical: 18),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(30),
          borderSide: BorderSide.none,
        ),
      ),
    );
  }
}
