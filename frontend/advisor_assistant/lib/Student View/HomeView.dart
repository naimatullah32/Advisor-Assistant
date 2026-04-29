import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../res/routes/routes_name.dart';
import '../view_models/controller/user_preference/user_prefrence_view_model.dart';

class StudentHomeView extends StatefulWidget {
  const StudentHomeView({super.key});

  @override
  State<StudentHomeView> createState() => _StudentHomeViewState();
}
UserPreference userPreference = UserPreference();

class _StudentHomeViewState extends State<StudentHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Student Home View"),
      ),
      body: Column(
        mainAxisAlignment: .center,
        children: [
          ElevatedButton(onPressed: (){
            userPreference.removeUser().then((value) {
              Get.offAllNamed(RouteName.loginView);
            });
          }, child: Text("Log Out"))
        ],
      ),
    );
  }
}
