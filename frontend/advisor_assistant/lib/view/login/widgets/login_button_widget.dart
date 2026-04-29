import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../../res/components/round_button.dart';
import '../../../view_models/controller/login/login_view_model.dart';

class LoginButtonWidget extends StatelessWidget {
  final GlobalKey<FormState> formKey;

  LoginButtonWidget({Key? key, required this.formKey}) : super(key: key);

  final loginVM = Get.put(LoginViewModel());

  @override
  Widget build(BuildContext context) {
    return Obx(
          () => RoundButton(
        width: double.infinity, // full width
        height: 55, // nice button height
        title: 'login'.tr,
        loading: loginVM.loading.value,
        buttonColor: const Color(0xff1E1B5E), // dark blue
        textColor: Colors.white,
        borderRadius: 30, // rounded like design
        onPress: () {
          if (formKey.currentState!.validate()) {
            loginVM.loginApi();
          }
        },
      ),
    );
  }
}
