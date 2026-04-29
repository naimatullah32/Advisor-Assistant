

import 'package:advisor_assistant/Admin%20View/adminDashboard.dart';
import 'package:advisor_assistant/Advisor%20View/advisorDashboard.dart';
import 'package:advisor_assistant/Parents%20View/HomeView.dart';
import 'package:advisor_assistant/Student%20View/HomeView.dart';
import 'package:advisor_assistant/Teacher%20View/HomeView.dart';
import 'package:advisor_assistant/res/routes/routes_name.dart';
import 'package:advisor_assistant/view/login/login_view.dart';
import 'package:get/get.dart';

import '../../view/splash_screen.dart';
class AppRoutes {

  static appRoutes() => [
    GetPage(
      name: RouteName.splashScreen,
      page: () => SplashScreen() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.loginView,
      page: () => LoginView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.adminHomeView,
      page: () => AdminHomeView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.teacherHomeView,
      page: () => TeacherHomeView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.advisorHomeView,
      page: () => AdvisorHomeView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.parentHomeView,
      page: () => ParentHomeView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,
    GetPage(
      name: RouteName.studentHomeView,
      page: () => StudentHomeView() ,
      transitionDuration: Duration(milliseconds: 250),
      transition: Transition.leftToRightWithFade ,
    ) ,

  ];

}