

import 'dart:async';

import 'package:get/get.dart';
import '../../res/routes/routes_name.dart';
import '../controller/user_preference/user_prefrence_view_model.dart';

class SplashServices {

  UserPreference userPreference = UserPreference();

  void isLogin() {

    userPreference.getUser().then((value) {

      if (value.isLogin == true) {

        switch (value.role) {

          case 'advisor':
            Get.offAllNamed(RouteName.advisorHomeView);
            break;

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

          default:
            Get.offAllNamed(RouteName.loginView);
        }

      } else {
        Get.offAllNamed(RouteName.loginView);
      }

    });
  }

}