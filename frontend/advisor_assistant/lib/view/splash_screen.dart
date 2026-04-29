import 'package:advisor_assistant/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../res/routes/routes_name.dart';
import '../view_models/services/splash_services.dart';


class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  SplashServices splashScreen = SplashServices();
  UserPreference userPreference = UserPreference();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    splashScreen.isLogin();

  }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      backgroundColor: Colors.teal,
      body: Container(
        height: double.infinity,
        width: double.infinity,
        color: Color(0xff1E1B5E),
        child: Padding(
          padding: const EdgeInsets.only(top: 200),
          child: Column(
            children: [
              Center(
                child: CircleAvatar(
                  radius: 90,
                  backgroundImage: AssetImage("assets/images/logo.webp"),
                  backgroundColor: Colors.white,
                ),
              ),
              SizedBox(height: 20),
              Text(
                "Advisor Assistant",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 34,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      )
    );
  }
}
