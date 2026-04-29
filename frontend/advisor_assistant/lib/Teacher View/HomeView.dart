import 'package:advisor_assistant/view_models/controller/user_preference/user_prefrence_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../res/routes/routes_name.dart';

class TeacherHomeView extends StatefulWidget {
  const TeacherHomeView({super.key});

  @override
  State<TeacherHomeView> createState() => _TeacherHomeViewState();
}
   UserPreference userPreference = UserPreference();
class _TeacherHomeViewState extends State<TeacherHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Teacher Home View"),
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
