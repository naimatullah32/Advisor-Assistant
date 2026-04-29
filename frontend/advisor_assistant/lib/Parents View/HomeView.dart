import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';

import '../res/routes/routes_name.dart';
import '../view_models/controller/user_preference/user_prefrence_view_model.dart';

class ParentHomeView extends StatefulWidget {
  const ParentHomeView({super.key});

  @override
  State<ParentHomeView> createState() => _ParentHomeViewState();
}
UserPreference userPreference = UserPreference();

class _ParentHomeViewState extends State<ParentHomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Parent Home View"),
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
