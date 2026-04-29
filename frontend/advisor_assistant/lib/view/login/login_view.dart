import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../view_models/controller/login/login_view_model.dart';
import 'widgets/input_email_widget.dart';
import 'widgets/input_password_widget.dart';
import 'widgets/login_button_widget.dart';

class LoginView extends StatefulWidget {
  const LoginView({Key? key}) : super(key: key);

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final loginVM = Get.put(LoginViewModel());
  final _formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: const Color(0xff1E1B5E),
      body: Stack(
        children: [

          /// Top Background
          Container(
            height: MediaQuery.of(context).size.height * 0.45,
            decoration: const BoxDecoration(
              color: Color(0xff1E1B5E),
            ),
            child: Column(
              children: const [
                SizedBox(height: 60),
                Center(
                  child: CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage("assets/images/logo.webp"),
                    backgroundColor: Colors.white,
                  ),
                ),
                SizedBox(height: 20),
                Text(
                  "Advisor Assistant",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                )
              ],
            ),
          ),

          /// Bottom White Card
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: MediaQuery.of(context).size.height * 0.65,
              padding: const EdgeInsets.symmetric(horizontal: 25),
              decoration: const BoxDecoration(
                color: Color(0xffEAEAEA),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(40),
                  topRight: Radius.circular(40),
                ),
              ),
              child: Form(
                key: _formkey,
                child: Padding(
                  padding: const EdgeInsets.only(top: 100),
                  child: Column(
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      InputEmailWidget(),
                      const SizedBox(height: 20),
                      InputPasswordWidget(),
                      const SizedBox(height: 40),
                      LoginButtonWidget(formKey: _formkey),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
